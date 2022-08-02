import os
from pathlib import Path
import json
import plistlib


# Utils ===============================================================================================


def replace_text(file_path, original, replacement):
    with open(Path(file_path), "r") as f:
        file_data = f.read()
    with open(Path(file_path), "w") as f:
        f.write(file_data.replace(original, replacement))


def move_file(file_path, new_path):
    os.rename(Path(file_path), Path(new_path))


def delete_lines_containing(file_path, text):
    with open(Path(file_path), "r") as f:
        file_data = f.read()
    with open(Path(file_path), "w") as f:
        f.write(file_data.replace(text, ""))


def file_exists(file_path):
    return os.path.isfile(Path(file_path))


def recursively_replace_text(directory, original, replacement):
    # Recursively replace in all directories inside directory
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".dart"):
                replace_text(os.path.join(root, file), original, replacement)


# Verify ===============================================================================================


class FlutterFirebaseTemplate:
    def __init__(self, flutter_package_name):
        self.android_application_name = None
        self.ios_bundle_name = None
        self.app_display_name = None
        self.flutter_package_name = flutter_package_name

        app_display_name_parts = flutter_package_name.split("_")
        self.app_display_name = " ".join(map(str.capitalize, app_display_name_parts))

    def verify(self):
        for file in [
            "lib/firebase_options.dart",
            "android/app/google-services.json",
            "ios/firebase_app_id_file.json",
            "ios/Runner/GoogleService-Info.plist",
        ]:
            if not file_exists(file):
                print(f"{file} is missing")
                print("Please configure firebase in your project using 'flutterfire configure'")
                print("https://firebase.flutter.dev/docs/overview/#using-the-flutterfire-cli")
                print("Please note that you may neeed touse atleast flutterfire 0.2.4")
                raise Exception("Missing firebase configuration")

        print("Extracting android application id from google-services.json")
        with open("android/app/google-services.json", "r") as f:
            google_services_json = json.load(f)
            client_data = google_services_json["client"][0]
            self.android_application_id = client_data["client_info"]["android_client_info"]["package_name"]

        print("Extracting ios bundle name from GoogleService-Info.plist")
        with open("ios/Runner/GoogleService-Info.plist", "rb") as f:
            google_service_info_plist = plistlib.load(f)
            self.ios_bundle_name = google_service_info_plist["BUNDLE_ID"]

        print("==== Project verification complete ====")
        print(f"Android application id: {self.android_application_id}")
        print(f"iOS bundle name: {self.ios_bundle_name}")
        print(f"Flutter package name: {self.flutter_package_name}")
        print(f"App display name: {self.app_display_name}")

    def configure(self):
        # Android

        print("Fixing android folders")
        for file in [
            "android/app/build.gradle",
            "android/app/src/main/AndroidManifest.xml",
            "android/app/src/debug/AndroidManifest.xml",
            "android/app/src/profile/AndroidManifest.xml",
            "android/app/src/main/kotlin/com/example/flutter_firebase_template/MainActivity.kt",
        ]:
            replace_text(file, "com.example.flutter_firebase_template", self.android_application_name)
        replace_text(
            "android/app/src/main/AndroidManifest.xml",
            "flutter_firebase_template",
            self.android_application_name.split(".")[-1],
        )
        move_file(
            "android/app/src/main/kotlin/com/example/flutter_firebase_template/MainActivity.kt",
            f"android/app/src/main/kotlin/{self.android_application_name.replace('.', '/')}/MainActivity.kt",
        )

        # iOS

        print("Fixing iOS folders")
        replace_text(
            "ios/Runner.xcodeproj/project.pbxproj",
            "com.example.flutterFirebaseTemplate",
            self.ios_bundle_name,
        )
        replace_text(
            "ios/Runner/Info.plist",
            "Flutter Firebase Template",
            self.app_display_name,
        )
        replace_text(
            "ios/Runner/Info.plist",
            "flutter_firebase_template",
            self.android_application_name.split(".")[-1],
        )

        # Flutter

        print("Fixing Flutter folders")
        replace_text(
            "pubspec.yaml",
            "flutter_firebase_template",
            self.flutter_package_name,
        )
        recursively_replace_text(
            "lib",
            "package:flutter_firebase_template",
            f"package:{self.flutter_package_name}",
        )
        recursively_replace_text(
            "test",
            "package:flutter_firebase_template",
            f"package:{self.flutter_package_name}",
        )

        # Fix gitignore
        print("Fixing gitignore")
        with open("gitignore", "r") as f:
            gitignore = f.read()
            for remove_line in [
                "# Remove following after configuring firebase",
                "firebase_app_id_file.json",
                "GoogleService-Info.plist",
                "google-services.json",
            ]:
                for line in gitignore.split("\n"):
                    if line.startswith(remove_line):
                        delete_lines_containing("gitignore", line)


# Main ===============================================================================================


def main():
    try:
        flutter_package_name = input("Enter your flutter package name: ").strip()
        if not flutter_package_name:
            raise Exception("Flutter package name is required")

        project = FlutterFirebaseTemplate(flutter_package_name)
        project.verify()
        project.configure()
    except Exception as e:
        print("Something went wrong:", e)


if __name__ == "__main__":
    main()
