import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cgpa_calculator/ux/shared/resources/app_images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cgpa_calculator/platform/extensions/string_extensions.dart';

// ignore: must_be_immutable
class AppImageWidget extends StatelessWidget {
  String? baseUrl;
  String? imageUrl;
  File? file;
  AssetImage? image;
  AssetImage? placeHolder;
  AssetImage? errorImage;
  double? width;
  double height = 64;
  double? borderRadius;
  BoxFit? boxFit;
  Widget? child;
  bool showPlaceHolder;
  BorderRadiusGeometry? borderRadiusGeometry;

  AppImageWidget(
      {super.key,
      this.baseUrl,
      required this.imageUrl,
      this.placeHolder,
      this.errorImage,
      this.borderRadius,
      this.width,
      this.height = 64,
      this.boxFit = BoxFit.cover,
      this.child,
      this.showPlaceHolder = true});

  AppImageWidget.local({
    super.key,
    required this.image,
    this.width = 64,
    this.height = 64,
    this.borderRadius,
    this.boxFit,
    this.child,
    this.showPlaceHolder = true,
    this.borderRadiusGeometry,
  });

  AppImageWidget.file(
      {super.key,
      required this.file,
      this.width = 64,
      this.height = 64,
      this.borderRadius,
      this.boxFit = BoxFit.cover,
      this.child,
      this.showPlaceHolder = true});

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: borderRadiusGeometry ??
                    BorderRadius.circular(borderRadius ?? 8),
                child: Image(
                  image: image ?? AppImages.appLogo,
                  width: width,
                  height: height,
                  fit: boxFit,
                  errorBuilder: (context, o, s) {
                    return Image(
                      image: placeHolder ?? AppImages.profilePlaceholder,
                      width: width,
                      height: height,
                    );
                  },
                )),
            child ?? const SizedBox.shrink(),
          ],
        ),
      );
    }

    if (file != null) {
      return SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                child: Image.file(
                  file!,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                  errorBuilder: (context, o, s) {
                    return Image(
                      image: placeHolder ?? AppImages.profilePlaceholder,
                      width: width,
                      height: height,
                    );
                  },
                )),
            child ?? const SizedBox.shrink(),
          ],
        ),
      );
    }

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              child: imageUrl.isNullOrBlank == false
                  ? CachedNetworkImage(
                      fit: boxFit,
                      imageUrl:
                          ((baseUrl?.isNotEmpty == true ? baseUrl : '') ?? '') +
                              (imageUrl ?? ''),
                      width: width,
                      height: height,
                      placeholder: showPlaceHolder
                          ? (
                              context,
                              o,
                            ) {
                              return Image(
                                image:
                                    placeHolder ?? AppImages.profilePlaceholder,
                                fit: boxFit,
                                width: width,
                                height: height,
                              );
                            }
                          : null,
                      errorWidget: (context, o, s) {
                        return Image(
                          image: errorImage ?? AppImages.profilePlaceholder,
                          fit: boxFit,
                          width: width,
                          height: height,
                        );
                      },
                      errorListener: (value) {
                        if (kDebugMode) {
                          print('Error loading image: $baseUrl$imageUrl');
                        }
                      })
                  : Image(
                      image: errorImage ?? AppImages.profilePlaceholder,
                      fit: boxFit,
                      width: width,
                      height: height,
                    )),
          child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
