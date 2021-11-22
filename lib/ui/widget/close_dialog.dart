import 'package:dormitory_manager/resources/colors.dart';
import 'package:dormitory_manager/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer_util.dart';


class CloseDialog extends StatelessWidget {
  final Function onClose;
  final Color color;

  const CloseDialog({Key key, this.onClose, this.color = AppColors.colorWhite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Icon(
        Icons.clear,
        color: color,
        size: !(SizerUtil.deviceType == DeviceType.Tablet)
            ? AppDimensions.d6w
            : AppDimensions.d5w,
      ),
    );
  }
}
