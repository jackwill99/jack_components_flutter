import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jack_components/ui/dialog/jack_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class JackCoordinate {
  final double latitude;
  final double longitude;
  JackCoordinate({required this.latitude, required this.longitude});
}

class AdministrativeArea {
  late String country;
  late String level1;
  late String level2;
  late String level3;
  late String level4;

  set setCountry(String value) {
    country = value;
  }

  set setLevel1(String value) {
    level1 = value;
  }

  set setLevel2(String value) {
    level2 = value;
  }

  set setLevel3(String value) {
    level3 = value;
  }

  set setLevel4(String value) {
    level4 = value;
  }
}

///  # GeoLocation & Reverse-Geocoding API
/// `@Author Jack`
///
/// At first, check [flutter_geolocator](https://pub.dev/packages/geolocator) and set-up location permissions.
///
/// The `determinePosition` method of `GeoLocation` will give u the latitude and longitude.
///
/// The transformation of human readable address from the latitude and longitude is called `Reverse-Geocoding` and u can call `reverseGeocoding` method
///
/// This API will return so many objects. According to analysis,
/// - `administrative_area_level_1` is Region or State of Country.
/// - `administrative_area_level_2` is District , Division(eg. Yangon West) or Region(sometimes itself is also level 2 when there is the most of level 3 eg. Amarapura Township) of Country.
/// - `administrative_area_level_3` is Township.
/// - `administrative_area_level_4` is Village or Township(sometimes township itself is also level 4 when there is the most of level 3 eg. Amarapura Township).
///     - eg.
///       ```json
///    "address_components": [
///       {
///          "name": "Amarapura",
///          "types":  "administrative_area_level_4",
///       },
///       {
///          "name": "Amarapura",
///          "types": "administrative_area_level_3",
///       },
///       {
///          "name": "Mandalay",
///          "types": "administrative_area_level_2",
///       },
///       {
///          "name": "Mandalay Region",
///          "types": "administrative_area_level_1",
///       ]
///       },
///       {
///          "name": "Myanmar (Burma)",
///          "types": "country",
///       }
///    ],
///       ```
class JackGeoLocation {
  const JackGeoLocation();

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position?> determinePosition({required BuildContext context}) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return await _generalModalDialog(
        context: context,
        title: "Location service",
        desc: "Location service needs to be enable.",
        okText: "Settings",
        confirm: () async {
          Geolocator.openLocationSettings();
        },
      ).then((value) {
        return null;
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return await _generalModalDialog(
          context: context,
          title: "Location Permission",
          desc: "Location permission needs to be enable.",
          okText: "Settings",
          confirm: () async {
            openAppSettings();
          },
        ).then((value) {
          return null;
        });
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return await _generalModalDialog(
        context: context,
        title: "Location Permission",
        desc:
            "Location permissions are permanently denied, we cannot request permissions.",
        okText: "Settings",
        confirm: () async {
          openAppSettings();
        },
      ).then((value) {
        return null;
      });
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// The best way of transforming `Reverse-Geocoding` is calling to google reverse-geocoding APIs.
  ///
  /// `https://maps.googleapis.com/maps/api/geocode/json?latlng=21.6702542,95.9236960&key=YOUR_API_KEY`
  Future<AdministrativeArea?> reverseGeocoding(
      {required String googlePlaceApiKey,
      required JackCoordinate coordinate}) async {
    try {
      final Response response = await Dio().get(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinate.latitude},${coordinate.longitude}&key=$googlePlaceApiKey");
      final responseData = response.data as Map<String, dynamic>;
      final addresses = responseData["results"];

      late Map administrativeAreaLevel4;
      late Map administrativeAreaLevel3;
      final administrative = AdministrativeArea();

      for (var address in addresses) {
        final types = address['types'] as List;
        for (var type in types) {
          switch (type) {
            case "administrative_area_level_4":
              administrativeAreaLevel4 = address;
              break;
            case "administrative_area_level_3":
              administrativeAreaLevel3 = address;
              break;
            default:
          }
        }
      }

      final addressesComponents4 =
          administrativeAreaLevel4['address_components'] as List;
      for (var address in addressesComponents4) {
        final types = address['types'] as List;
        for (var type in types) {
          switch (type) {
            case "administrative_area_level_4":
              administrative.setLevel4 = address['long_name'];
              break;
            case "administrative_area_level_2":
              administrative.setLevel2 = address['long_name'];
              break;
            case "administrative_area_level_1":
              final level1 = (address['long_name'] as String)
                  .replaceAll("Region", "")
                  .trim();
              administrative.setLevel1 = level1;
              break;
            case "country":
              administrative.setCountry = address['long_name'];
              break;
            default:
          }
        }
      }

      final addressesComponents3 =
          administrativeAreaLevel3['address_components'] as List;
      for (var address in addressesComponents3) {
        final types = address['types'] as List;
        for (var type in types) {
          switch (type) {
            case "administrative_area_level_3":
              final level3 = (address['long_name'] as String)
                  .replaceAll("Township", "")
                  .trim();
              administrative.setLevel3 = level3;
              break;
            default:
          }
        }
      }
      return administrative;
    } catch (e) {
      return null;
    }
  }

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

Future<void> _generalModalDialog({
  required BuildContext context,
  required String title,
  required String desc,
  TextAlign? descAlign,
  Widget? img,
  Future<void> Function()? confirm,
  Future<void> Function()? cancel,
  bool? cancelButton,
  bool? barrierDismissible,
  String? cancelText,
  String? okText,
  double? imgAssetPaddingBottom,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    builder: (context) {
      return JackUIDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        description: Text(
          desc,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
          textAlign: descAlign ?? TextAlign.center,
        ),
        button: LayoutBuilder(builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (cancelButton != null)
                SizedBox(
                  width: cancelButton
                      ? (constraints.maxWidth / 2) - 10
                      : constraints.maxWidth - 5,
                  child: ElevatedButton(
                    onPressed: () {
                      cancel?.call();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromHeight(45),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      cancelText ?? 'CANCEL',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            // color: Colors.white,
                            fontSize: 15,
                          ),
                    ),
                  ),
                ),
              if (cancelButton != null)
                const SizedBox(
                  width: 10,
                ),
              SizedBox(
                width: (cancelButton != null)
                    ? (constraints.maxWidth / 2) - 10
                    : constraints.maxWidth - 5,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await confirm?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size.fromHeight(45),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    okText ?? 'OK',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
        bottomSpacing: const Padding(padding: EdgeInsets.only(bottom: 0)),
        topImage: img != null
            ? Center(
                child: Container(
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.red)),
                  padding: EdgeInsets.only(bottom: imgAssetPaddingBottom ?? 40),
                  child: img,
                ),
              )
            : null,
      );
    },
  );
}
