import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aron_invoice/generate_invoice.dart';
import 'package:aron_invoice/invoice.dart';
import 'package:aron_invoice/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  bool _mainContentVisible = true;
  bool _showAnimation = false;

  late final _fadeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  late final _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

  Timer? _timer;

  final invoiceNumberController = TextEditingController(text: exampleInvoice.invoiceNumber);
  final issueDateController = TextEditingController(text: exampleInvoice.issueDate);
  final saleDateController = TextEditingController(text: exampleInvoice.saleDate);
  final sellerController = TextEditingController(text: exampleInvoice.seller);
  final buyerController = TextEditingController(text: exampleInvoice.buyer);

  final descriptionController = TextEditingController(text: exampleInvoice.productList.first.description);
  final netPriceController = TextEditingController(text: exampleInvoice.productList.first.netPrice.toString());
  final vatRateController = TextEditingController(text: exampleInvoice.productList.first.vatRate.toString());
  final currencyController = TextEditingController(text: exampleInvoice.productList.first.currency);

  final additionalDescriptionController = TextEditingController(text: exampleInvoice.additionalDescription);

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/image.png'), context).then((value) {
      if (_timer == null) {
        _timer = Timer(const Duration(seconds: 5), () => setState(() => _showAnimation = true));
        _fadeController.forward();
      }
    });

    return Scaffold(
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _mainContentVisible
                    ? _buildMainContent(
                        onShowFormPressed: () => setState(() => _mainContentVisible = false),
                      )
                    : _buildGenerateForm(
                        onGenerateInvoicePressed: (Invoice invoice) => generateInvoice(invoice),
                      ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          fontFamily: 'RobotoBold',
        );

    return AppBar(
      backgroundColor: Colors.transparent,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Aron', style: textStyle),
                TextSpan(text: 'Invoice', style: textStyle?.copyWith(color: Colors.amberAccent)),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          _showAnimation == false
              ? const SizedBox()
              : AnimatedTextKit(
                  totalRepeatCount: 1,
                  repeatForever: false,
                  pause: const Duration(seconds: 2),
                  animatedTexts: [
                    TyperAnimatedText(
                      'bez S',
                      textStyle: textStyle?.copyWith(color: Theme.of(context).colorScheme.outline),
                      speed: const Duration(milliseconds: 100),
                      curve: Curves.linear,
                    ),
                    TypewriterAnimatedText(
                      'bez KSeF',
                      textStyle: textStyle?.copyWith(color: Theme.of(context).colorScheme.outline),
                      speed: const Duration(milliseconds: 100),
                      curve: Curves.linear,
                    ),
                  ],
                ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => launchUrl(Uri.parse('https://github.com/arononak/aron_invoice')),
          icon: const Icon(Icons.code),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          onPressed: () => showLicensePage(context: context),
          icon: const Icon(Icons.gavel),
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }

  Widget _buildMainContent({required VoidCallback onShowFormPressed}) {
    return MediaQuery.of(context).size.width < 1100
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeftContent(onShowFormPressed),
              const SizedBox(height: 64),
              _buildRightContent(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeftContent(onShowFormPressed),
              const SizedBox(width: 64),
              _buildRightContent(),
            ],
          );
  }

  Widget _buildGenerateForm({required void Function(Invoice invoice) onGenerateInvoicePressed}) {
    return Column(
      children: [
        buildTextField(
          controller: invoiceNumberController,
          labelText: 'Numer faktury',
        ),
        const SizedBox(height: 32.0),
        buildTextField(
          controller: saleDateController,
          labelText: 'Data sprzedaży',
        ),
        const SizedBox(height: 8.0),
        buildTextField(
          controller: issueDateController,
          labelText: 'Data wystawienia',
        ),
        const SizedBox(height: 32.0),
        buildTextField(
          controller: sellerController,
          maxLines: 5,
          labelText: 'Sprzedawca',
        ),
        const SizedBox(height: 8.0),
        buildTextField(
          controller: buyerController,
          maxLines: 5,
          labelText: 'Nabywca',
        ),
        const SizedBox(height: 32.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: buildTextField(
                controller: descriptionController,
                labelText: 'Opis towaru/usługi',
              ),
            ),
            const SizedBox(width: 8.0),
            buildTextField(
              controller: netPriceController,
              labelText: 'Kwota netto',
              maxWidth: 100,
            ),
            const SizedBox(width: 8.0),
            buildTextField(
              controller: vatRateController,
              labelText: 'VAT',
              maxWidth: 60,
            ),
            const SizedBox(width: 8.0),
            buildTextField(
              controller: currencyController,
              labelText: 'Waluta',
              maxWidth: 65,
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        buildTextField(
          controller: additionalDescriptionController,
          labelText: 'Uwagi',
          maxLines: 5,
        ),
        const SizedBox(height: 16.0),
        buildButton(
          context: context,
          text: 'Generuj',
          onPressed: () {
            final product = Product(
              description: descriptionController.text,
              netPrice: double.parse(netPriceController.text),
              vatRate: double.parse(vatRateController.text),
              currency: currencyController.text,
            );

            final invoice = Invoice(
              invoiceNumber: invoiceNumberController.text,
              issueDate: issueDateController.text,
              saleDate: saleDateController.text,
              seller: sellerController.text,
              buyer: buyerController.text,
              productList: [
                product,
              ],
              additionalDescription: additionalDescriptionController.text,
            );

            onGenerateInvoicePressed(invoice);
          },
        ),
      ],
    );
  }

  Widget _buildLeftContent(VoidCallback onGeneratePressed) {
    final textStyle = GoogleFonts.openSans(
      textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -2,
          ),
    );

    final subtitleTextStyle = GoogleFonts.inter(
      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.outline,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
    );

    return SizedBox(
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Generuj faktury\nza darmo', style: textStyle),
              const SizedBox(height: 32),
              Text(
                'Aby zapewnić prywatność, faktury są tworzone po stronie przeglądarki, nie na poziomie serwera.',
                style: subtitleTextStyle,
              ),
              const SizedBox(height: 32),
              ...[
                'Kod jest publiczny, czyli nie może się stać płatne',
                'Uczciwa cena czyli darmo',
                'Żadne regulaminy, ciasteczka, RODO i polityki prywatności',
                'Nie ma AI i nie będzie',
              ].map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          buildButton(
            context: context,
            text: 'Generuj',
            onPressed: onGeneratePressed,
          ),
        ],
      ),
    );
  }

  Widget _buildRightContent() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/image.png',
          width: 210 * 1.9,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 100),
        const Text('Wersja 1.0.0'),
        const SizedBox(height: 16.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.copyright, size: 20),
            const SizedBox(width: 6),
            Text('Aron Code ${DateTime.now().year}'),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
