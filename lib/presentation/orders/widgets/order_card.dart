import 'package:flutter/material.dart';
import 'package:flutter_smilelaundry_user/data/models/responses/history_order_response_model.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
// import '../../home/models/product_quantity.dart';
// import '../models/transaction_model.dart';
// import '../pages/order_detail_page.dart';
import 'row_text.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderOrder data;
  final List<Product> products;
  const OrderCard({Key? key, required this.data, required this.products});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${data.id ?? '-'}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Button.filled(
                  onPressed: () {},
                  label: data.orderStatus!,
                  height: 20.0,
                  width: 110.0,
                  fontSize: 11.0,
                ),
              ],
            ),
            const SpaceHeight(24.0),
            RowText(
              label: 'Date',
              value: DateFormat('dd-MM-yyyy').format(data.orderDate!),
            ),
            const SpaceHeight(5.0),
            RowText(label: 'Status Payment', value: data.paymentStatus ?? '-'),
            const SpaceHeight(5.0),
            const Divider(),
            const SpaceHeight(5.0),
            ...products.map((product) {
              final productName = product.name ?? '-';
              final quantityText =
                  (productName.toLowerCase().contains('paket') &&
                          (data.orderStatus == 'Pending' ||
                              data.orderStatus == 'Picking Up'))
                      ? '? Kg'
                      : '${product.quantity ?? 1}';
              final priceText = (productName.toLowerCase().contains('paket') &&
                      (data.orderStatus == 'Pending' ||
                          data.orderStatus == 'Picking Up'))
                  ? 'Pending'
                  : (product.price ?? 0).currencyFormatRp;

              return RowText(
                label: '$productName x $quantityText',
                value: priceText,
              );
            }).toList(),
            const SpaceHeight(5.0),
            const Divider(),
            const SpaceHeight(10.0),
            RowText(
              label: 'Total Harga',
              value: getTotalPrice().currencyFormatRp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  String getProductPrice(Product product) {
    if (product.name!.toLowerCase().contains('paket') &&
        (data.orderStatus == 'Pending' || data.orderStatus == 'Picking Up')) {
      return 'Pending';
    } else {
      return (product.price ?? 0).currencyFormatRp;
    }
  }

  int getTotalPrice() {
    return products.fold<int>(
      0,
      (total, product) =>
          total +
          ((product.name!.toLowerCase().contains('paket') &&
                  (data.orderStatus == 'Pending' ||
                      data.orderStatus == 'Picking Up'))
              ? 0
              : (product.price ?? 0) * (product.quantity ?? 1)),
    );
  }
}
