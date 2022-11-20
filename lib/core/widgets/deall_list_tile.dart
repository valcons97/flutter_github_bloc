import 'package:cached_network_image/cached_network_image.dart';
import 'package:deall/core/core.dart';
import 'package:flutter/material.dart';

class DeallListTile extends StatelessWidget {
  const DeallListTile({
    super.key,
    required this.title,
    required this.imageUrl,
    this.subTitle,
    this.borderRadius,
    this.trailingTitle,
    this.trailingSubTitle,
    this.trailingSubTitle2,
  });

  factory DeallListTile.users({
    Key? key,
    required String user,
    required String imageUrl,
  }) {
    return DeallListTile(
      title: user,
      imageUrl: imageUrl,
    );
  }

  factory DeallListTile.issues({
    Key? key,
    required String title,
    required String imageUrl,
    required String updateDate,
    required String issues,
    required String states,
  }) {
    return DeallListTile(
      title: title,
      imageUrl: imageUrl,
      subTitle: updateDate,
      trailingTitle: issues,
      trailingSubTitle: states,
    );
  }

  factory DeallListTile.repo({
    Key? key,
    required String repoTitle,
    required String imageUrl,
    required String createdDate,
    required String watchers,
    required String stars,
    required String forks,
  }) {
    return DeallListTile(
      title: repoTitle,
      imageUrl: imageUrl,
      subTitle: createdDate,
      trailingTitle: watchers,
      trailingSubTitle: stars,
      trailingSubTitle2: forks,
    );
  }

  final String title;

  final String imageUrl;

  final String? subTitle;

  final String? trailingTitle;

  final String? trailingSubTitle;

  final String? trailingSubTitle2;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: context.res.colors.bgGradient,
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: context.res.colors.lightOrange2,
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 2),
              )
            ]),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: context.res.colors.navy),
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: context.res.styles.body1,
                  ),
                  Text(
                    subTitle ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: context.res.styles.body2,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trailingTitle ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: context.res.styles.body2,
                ),
                Text(
                  trailingSubTitle ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: context.res.styles.body2,
                ),
                Text(
                  trailingSubTitle2 ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: context.res.styles.body2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
