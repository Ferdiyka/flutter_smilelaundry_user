// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smile Laundry',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Sapto Atmojo',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '(WA) : 081389073557',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Alamat Kami: Jalan Inpres 4 RT 02 RW 06 Larangan Utara, RT.001/RW.006, Larangan Utara, Kec. Larangan, Kota Tangerang, Banten 15154',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Smile Laundry adalah penyedia jasa layanan laundry mulai dari mencuci, setrika, mengeringkan, hingga antar-jemput pakaian. Tak hanya menyediakan kiloan, Smile Laundry juga menyediakan opsi mencuci produk secara satuan seperti sepatu dan helm',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16.0),
              Text(
                'Rules',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Untuk layanan antar-jemput kami akan memberikan harga gratis bagi pelanggan yang berada dalam jangkauan radius kami yaitu kurang dari sama dengan 500 meter. Jika Aplikasi mendeteksi bahwa Anda memiliki jangkauan radius di atas itu maka kami tidak bisa memberikan layanan antar-jemput tersebut. Bagi Anda yang diluar jangakauan radius Anda dapat menghubungi nomor WA atau datang langsung ke toko kami untuk informasi lebih lanjut',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                  height:
                      20.0), // tambahkan spasi di bagian bawah agar konten tidak terlalu dekat dengan tepi bawah
            ],
          ),
        ),
      ),
    );
  }
}
