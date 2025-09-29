import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:shimmer/shimmer.dart';

class NetworkImageWithPlaceholder extends StatefulWidget {
  final String imageUrl;
  final String placeholderAsset;
  final BoxFit? boxfit;
  double? height;
  double? width;

  NetworkImageWithPlaceholder({
    required this.imageUrl,
    required this.placeholderAsset,
    this.boxfit,
    this.height,
    this.width,
  });

  @override
  State<NetworkImageWithPlaceholder> createState() =>
      _NetworkImageWithPlaceholderState();
}

class _NetworkImageWithPlaceholderState
    extends State<NetworkImageWithPlaceholder> {
  final DefaultCacheManager cacheManager = DefaultCacheManager();
  Color? backgroundColor;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _getImageFromCache(widget.imageUrl),
      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            height: widget.height,
            width: widget.width,
            fit: widget.boxfit ?? BoxFit.contain,
          );
        } else {
          //1.1  20:47
          return CachedNetworkImage(
            cacheManager: cacheManager,
            imageUrl: widget.imageUrl,
            fit: widget.boxfit ?? BoxFit.contain,
            height: widget.height,
            width: widget.width,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Shimmer.fromColors(
                baseColor: HexColor("#999999"),
                highlightColor: Colors.grey[400]!,
                child: Container(color: Colors.white),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                width: widget.width,
                height: widget.height,
                color: Colors.grey[300],
                child: const Icon(Icons.book, color: Colors.grey),
              );
              //  widget.placeholderAsset.contains(".svg")
              //     ? SvgPicture.asset(
              //         widget.placeholderAsset,
              //         fit: widget.boxfit ?? BoxFit.contain,
              //       )
              //     : Image.asset(
              //         widget.placeholderAsset,
              //         height: widget.height,
              //         width: widget.width,
              //         fit: widget.boxfit ?? BoxFit.cover,
              //       );
            },
          );
        }
      },
    );
  }

  Future<File?> _getImageFromCache(String url) async {
    File? file;
    try {
      file = await cacheManager.getSingleFile(url);
    } catch (e) {}
    return file;
  }
}
