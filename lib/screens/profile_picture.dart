import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key, this.image, this.pixColor}) : super(key: key);
  final Color? pixColor;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0.w,
      height: 50.0.h,
      decoration: BoxDecoration(
        border: Border.all(width: 5.0, color: pixColor ?? Colors.transparent),
        shape: BoxShape.circle,
        image: DecorationImage(
          image: image != null && image!.isNotEmpty
              ? (Uri.tryParse(image!)?.isAbsolute ?? false
                  ? NetworkImage(image!)
                  : FileImage(File(image!))) as ImageProvider
              : AssetImage('assets/user.svg'),
          fit: BoxFit.cover,
        ),
      ),
      child: image == null
          ? SvgPicture.asset('assets/user.svg')
          : null,
    );
  }
}
