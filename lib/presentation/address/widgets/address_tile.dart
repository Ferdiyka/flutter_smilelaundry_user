// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_smilelaundry_user/data/models/responses/user_response_model.dart';

import '../../../core/components/spaces.dart';
import '../../../core/core.dart';

class AddressTile extends StatelessWidget {
  final User data;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  const AddressTile({
    Key? key,
    required this.data,
    required this.onTap,
    required this.onEditTap,
  }) : super(key: key); // Tambahkan super(key: key)

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 2),
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceHeight(24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                data.name!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SpaceHeight(4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      data.address!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      data.noteAddress!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      data.phone!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(20.0),
            const Divider(color: AppColors.fourthColor),
            Center(
              child: TextButton(
                onPressed: onEditTap,
                child: const Text('Edit Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
