# eksternal_app

Eksternal App For Pitik

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


for command easilier

Command	Description
gen	Generate files Reflect
run-dev	Running Debug with dev configuration
run-prod	Running Debug with production configuration
build-dev	Build aab file with debug configuration
build-prod	Build aab file with production configuration
apk-dev	Build apk file with debug configuration
apk-prod	Build apk file with production configuration
gen-flavor	FGenerate New flavor configuration
model-generator	Running Model Generator
Folder Structure
Here is the core folder structure which flutter provides.

mobile-flutter/
|- android
|- build
|- images
|- font
|- ios
|- lib
|- test
Here is the folder structure we have been using in this project

lib/
|- component/
|- engine/
|- ui/
|- app.dart
|- core.dart
|- flavors.dart
|- main_dev.dart
|- main_prod.dart
|- main.dart
|- main.reflectable.dart //Generated
|- model_generator_main.dart
Now, lets dive into the lib folder which has the main code for the application.

1- component — Contains the common widgets for this applications. For example, Button, TextField etc.
2- engine -
3- app.dart -
4- core.dart -
5- flavors.dart -
6- main_dev.dart -
7- main_prod.dart -
8- main.dart -
9- main.reflectable.dart -
10- model_generator_main.dart -
Component
Contains the common widgets that are shared across multiple screens. For example, Button, TextField etc.

widgets/
|- controller/
|- listener/
|- button_fill.dart
Engine
Contains the all the business logic of the application, it represents the data layer, application layer(repository). It is sub-divided into sixth directories dao, model, offline_capabillity, request, transport, and util

engine/
|- dao/
|- annotation/
|- impl/
|- base_entity.dart

|- model/
|- error/
|- response/
|- auth_model.dart

|- offlinecapability
|- offline_body/
|- offline.dart

|- request
|- annotation/
|- api.dart
|- service.dart

|- transport
|- body/
|- interface/
|- transporter.dart

|- util
|- interface/
|- mapper/
|- convert.dart

|- get_x_creator.dart
UI
This directory contains all the ui of your application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. All the screen have bussines logic specific will be placed in *_controller.dart as shown in the example below:

ui/
|- login/
|- login_screen.dart
|- login_controller.dart

|- home/
|- beranda/
|- beranda_screen.dart
|- beranda_controller.dart