
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_spacing.dart';
import '../widgets/label_and_textfield_widget.dart';

class CartSection extends StatelessWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(spacingSmall),
      child: Column(
        children: [
          LabelAndTextFieldWidget(
            label: 'Customer Number',
          ),
          SizedBox(
            height: spacingSmall,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset('assets/empty-box.png'),
            title: Text('Americano'),
            subtitle: Text('Rs. 189 x 12 qty'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset('assets/empty-box.png'),
            title: Text('Americano'),
            subtitle: Text('Rs. 189 x 12 qty'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset('assets/empty-box.png'),
            title: Text('Americano'),
            subtitle: Text('Rs. 189 x 12 qty'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset('assets/empty-box.png'),
            title: Text('Americano'),
            subtitle: Text('Rs. 189 x 12 qty'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset('assets/empty-box.png'),
            title: Text('Americano'),
            subtitle: Text('Rs. 189 x 12 qty'),
          ),
          SizedBox(
            height: spacingSmall,
          ),
          DottedLine(
            dashColor: AppColors.darkGrey,
          ),
          SizedBox(
            height: spacingSmall,
          ),
          Row(
            children: [],
          )
        ],
      ),
    );
  }
}
