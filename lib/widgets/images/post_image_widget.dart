import 'package:flutter/material.dart';

class PostImageWidget extends StatelessWidget {
  final String pictureurl;

  const PostImageWidget({super.key, required this.pictureurl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Image(
        width: MediaQuery.of(context).size.width,
        image: pictureurl != "NO_URL" ? NetworkImage(pictureurl) : const AssetImage('assets/placeholders/profile_placeholder.jpg'),
        fit: BoxFit.cover,
      ),
    );
  }
}
