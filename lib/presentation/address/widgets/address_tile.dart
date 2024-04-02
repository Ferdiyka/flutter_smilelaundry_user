import 'package:flutter/material.dart';

import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../models/address_model.dart';

class AddressTile extends StatelessWidget {
  final AddressModel data;
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
                data.name,
                style: const TextStyle(
                  fontSize: 16,
                ),
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
                      data.address,
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
                      data.phone,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(24.0),
            const Divider(color: AppColors.primary),
            Center(
              child: TextButton(
                onPressed: onEditTap,
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
