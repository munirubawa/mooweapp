import 'package:mooweapp/export_files.dart';

class RegisterBusiness extends StatefulWidget {
  const RegisterBusiness({Key? key}) : super(key: key);

  @override
  _RegisterBusinessState createState() => _RegisterBusinessState();
}

class _RegisterBusinessState extends State<RegisterBusiness> {
  final _formKey = GlobalKey<FormState>();
  String? code;
  bool requireCustomerAddress = false;

  AddressController addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Business registration",
          style: themeData!.textTheme.headline6!,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Start accepting payment for your business instantly"),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Owner: ${chatServices.localMember!.get(memberModel.firstName)} ${chatServices.localMember!.get(memberModel.lastName)}",
                      style: themeData!.textTheme.headline6,
                    ),
                  ),
                  // SettingsSection(
                  //   title: "Business info",
                  // ),
                  formFiled(
                    initialValue: businessServices.business.value.businessName ?? "",
                    textCapitalization: TextCapitalization.characters,
                    icon: const Icon(Icons.drive_file_rename_outline, color: Colors.grey),
                    labelText: "Business Name",
                    hintText: "Business Name",
                    validateString: "Business name required",
                    onChange: (value) {
                      print("$value");
                      setState(() {});
                      addressController.business.businessName = value;
                      businessServices.business.value.businessName = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: InternationalPhoneNumberInput(
                      initialValue: PhoneNumber(dialCode: "+1", isoCode: "US", phoneNumber: businessServices.business.value.phone),
                      inputBorder: const OutlineInputBorder(),
                      countries: authController!.setCountries,
                      keyboardType: TextInputType.phone,
                      onInputChanged: (PhoneNumber number) {
                        addressController.business.businessPhone = number.phoneNumber;
                        businessServices.business.value.businessPhone = number.phoneNumber;
                      },
                    ),
                  ),
                  formFiled(
                    initialValue: businessServices.business.value.address?? "",
                    textCapitalization: TextCapitalization.words,
                    icon: const Icon(Icons.place, color: Colors.grey),
                    labelText: "Business address",
                    hintText: "Address",
                    validateString: "Business address required",
                    onChange: (value) async {
                      print("$value");
                      addressController.business.address = value;
                      businessServices.business.value.address = value;

                      setState(() {});
                    },
                  ),
                  formFiled(
                    initialValue: businessServices.business.value.city?? "",
                    textCapitalization: TextCapitalization.words,
                    icon: const Icon(Icons.location_city, color: Colors.grey),
                    labelText: "City",
                    hintText: "City",
                    validateString: "City required",
                    onChange: (value) async {
                      print("$value");
                      setState(() {});
                      addressController.business.city = value;
                      businessServices.business.value.city = value;
                    },
                  ),
                  formFiled(
                    initialValue: businessServices.business.value.state?? "",
                    textCapitalization: TextCapitalization.words,
                    icon: const Icon(Icons.location_city, color: Colors.grey),
                    labelText: "State",
                    hintText: "State",
                    validateString: "State required",
                    onChange: (value) async {
                      print("$value");
                      addressController.business.state = value;
                      businessServices.business.value.state = value;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: formFiled(
                          initialValue: businessServices.business.value.zip?? "",
                          icon: const Icon(Icons.confirmation_number_outlined, color: Colors.grey),
                          labelText: "Zip Code",
                          hintText: "Zip Code",
                          keyboardType: TextInputType.number,
                          validateString: "State required",
                          onChange: (value) async {
                            print("$value");
                            addressController.zip.value = value ?? "";
                            businessServices.business.value.zip = value ?? "";
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SettingsSection(
                    title: "Customer Info",
                    // subtitle: Text("Start accepting payment for your business instantly"),
                    tiles: [
                      SettingsTile.switchTile(
                        title: 'Require customer address',
                        // leading: Icon(Icons.fingerprint),
                        switchValue: requireCustomerAddress,
                        onToggle: (bool value) {
                          setState(() {
                            requireCustomerAddress = value;
                          });
                        },
                      ),
                    ],
                  ),
                  FormBuilderCheckbox(
                    name: 'accept_terms',
                    initialValue: termsAndConditions,

                    onChanged: _onChanged,
                    title: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '1.75 % when received transaction. I have read and agree to the ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    validator: FormBuilderValidators.equal(
                      true,
                      errorText: 'You must accept terms and conditions to continue',
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomBtn(
                          bgColor: Colors.blue,
                          text: "Register",
                          onTap: () {
                            enumServices.businessServiceAction = BusinessServiceAction.CREATE_NEW_BUSINESS_ACCOUNT;
                            // businessServices.business = addressController.business;
                            businessServices.business.value.requireCustomerAddress = requireCustomerAddress;

                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              businessServices.runBusinessServices();
                              // _formKey.currentState!.save();
                              // _formKey.currentState!.validate();

                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  bool termsAndConditions = true;
  void _onChanged(bool? value) {
    termsAndConditions = value?? false;
  }
}

class PredictionTile extends StatelessWidget {
  final AutocompletePrediction prediction;

  const PredictionTile({Key? key, required this.prediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(flex: 2, child: Icon(Icons.add_location)),
            Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${prediction.description}",
                        overflow: TextOverflow.fade,
                        style: themeData!.textTheme.headline6,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ],
    );
  }
}
