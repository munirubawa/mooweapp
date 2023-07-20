import 'package:mooweapp/export_files.dart';

class AffiliateQRCode extends StatelessWidget {
  const AffiliateQRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children:  [
                  Text("${chatServices.localMember!.get(memberModel.firstName) }${chatServices.localMember!.get(memberModel.lastName)}"),
                  const Text("Affiliated Link")
                ],
              ),
            ),
              // QrImage(
              //   "https://mowe.app/ap=${chatServices.localMember!.get(memberModel.affiliateId)}",
              //   version: QrVersions.auto,
              //   size: 250,
              //   gapless: true,
              //   errorStateBuilder: (cxt, err) {
              //     return const Center(
              //       child: Text(
              //         "Uh oh! Something went wrong...",
              //         textAlign: TextAlign.center,
              //       ),
              //     );
              //   },
              //   // embeddedImage: const AssetImage('assets/ic_launcher.png'),
              //   // embeddedImageStyle: QrEmbeddedImageStyle(
              //   //   size: const Size(80, 80),
              //   // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
