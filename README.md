# Flutter Project Setup Instructions.

## Requirements
1.	API key from [etherscan.io](etherscan.io)
2.	Flutter version 3.35.5 (FVM may be required to switch between versions; more info: [fvm.app](fvm.app))

### Steps to Run
1. Create a folder call "env" under "assets" folder.
2. Create a json file name "develop", "uat" or "production", depending on which flavor you want to run.
3. Inside json file should look like this.
   ```json lines
   {
     "api_key": "API key from required item #1.",
     "wallet_address": "Main wallet address"
   }

4.1 Running from Android Studio (Recommended)
   - Set up Flutter for this project. If you’re using FVM, run: `fvm use 3.35.5`
   - Click the three-dot menu on the new debug button and select Edit.
   - In the Build flavor section, type one of these 3 flavors: develop, uat, or production.
   - Click OK.
   - Click Run or Debug.

4.2 Running from VSCode
   - Set up Flutter for this project. If using FVM, follow instructions on [fvm.app](fvm.app). 
   - Open terminal and type `flutter run --flavor ["develop", "uat", "production"]` select on of these 3 flavour. if you're using fvm, just adding fvm in front flutter command.

### Troubleshooting
If Android Studio does not detect the Flutter version selected via FVM:
1.	Go to Settings.
2.	Select Languages & Frameworks.
3.	Select Flutter.
4.	Check the Flutter version in the SDK section.
5.	If it does not match the desired version, change it to the correct version.
6.	Click Apply to ensure the version is selected.
7.	Click OK.