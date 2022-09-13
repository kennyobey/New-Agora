import 'package:agora_care/core/custom_form_field.dart';
import 'package:agora_care/services/auth_controller.dart';
import 'package:agora_care/services/cell_controller.dart';
import 'package:agora_care/widget/bottom_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constant/colors.dart';
import '../../core/customWidgets.dart';

class CreateCell extends StatefulWidget {
  const CreateCell({Key? key}) : super(key: key);

  @override
  State<CreateCell> createState() => _CreateCellState();
}

class _CreateCellState extends State<CreateCell> {
  final _authController = Get.find<AuthControllers>();
  final _cellController = Get.find<CellControllers>();

  final _chipController = TextEditingController();
  final _cellDescription = TextEditingController();
  final _cellNameController = TextEditingController();

  bool _isLoading = false;

  final List<String> _myListCustom = [];

  String email = "";
  String userName = "";
  String groupName = "";

  final _tagKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _cellNameController.clear();
    _cellDescription.clear();
    _myListCustom.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().whiteColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _tagKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customDescriptionText(
                "Create a new cell",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                colors: AppColor().lightTextColor,
              ),
              const Gap(30),
              CustomTextField(
                label: 'Cell name',
                hint: "Enter the name of this cell",
                minLines: 1,
                maxLines: 2,
                keyType: TextInputType.text,
                validatorText: '** Field cannot be empty',
                color: AppColor().lightTextColor,
                textEditingController: _cellNameController,
                fillColor: AppColor().fillColor,
              ),
              const Gap(20),
              CustomTextField(
                label: 'Description',
                hint: "Enter cell description",
                minLines: 2,
                maxLines: 5,
                keyType: TextInputType.text,
                validatorText: '** Field cannot be empty',
                color: AppColor().lightTextColor,
                textEditingController: _cellDescription,
                fillColor: AppColor().fillColor,
              ),
              const Gap(20),
              ChipTags(
                list: _myListCustom,
                separator: '',
                createTagOnSubmit: true,
                textColor: Colors.white,
                iconColor: Colors.white,
                inputController: _chipController,
                keyboardType: TextInputType.text,
                chipPosition: ChipPosition.above,
                chipColor: AppColor().primaryColor2,
                decoration: InputDecoration(
                  fillColor: AppColor().whiteColor,
                  filled: true,
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor().lightTextColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColor().lightTextColor, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColor().lightTextColor, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter Cell Tags",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Spacer(),
              CustomFillButton(
                isLoading: _isLoading,
                buttonText: 'Create Cell',
                textColor: AppColor().button1Color,
                buttonColor: AppColor().primaryColor,
                onTap: () async {
                  if (_tagKey.currentState!.validate()) {
                    if (kDebugMode) {
                      print('Creating Cell');
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    _cellController.createGroup(
                      admin: _authController.liveUser.value!.role!,
                      email: _authController.liveUser.value!.email!,
                      groupIcon: '',
                      groupId: '',
                      description: _cellDescription.text,
                      groupName: _cellNameController.text,
                      tags: _myListCustom,
                    );

                    setState(() {
                      _isLoading = false;
                    });
                    _cellNameController.clear();
                    _cellDescription.clear();
                    _myListCustom.clear();
                    if (kDebugMode) {
                      print('Done Creating Cell');
                    }
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: AppColor().whiteColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      context: context,
                      builder: (context) => GlobalDialogue(
                        text1: 'Cell created successfully',
                        text2:
                            'The cell is created and will be visible to all users',
                        asset: 'assets/svgs/success.svg',
                        action: () {
                          Get.close(1);
                        },
                      ),
                    );
                  }
                },
              ),
              const Gap(40)
            ],
          ),
        ),
      ),
    );
  }
}
