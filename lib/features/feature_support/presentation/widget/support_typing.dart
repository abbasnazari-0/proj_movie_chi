import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:movie_chi/core/utils/page_status.dart';
import 'package:movie_chi/features/feature_support/presentation/controllers/support_page_controller.dart';

class TypingSection extends StatelessWidget {
  const TypingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: GetBuilder<SupportPageController>(
          id: "typing",
          builder: (cont) {
            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    cont.sendMessage();
                  },
                  icon: cont.typeStatus == PageStatus.loading
                      ? const CircularProgressIndicator()
                      : const Icon(
                          Iconsax.send_1,
                          color: Colors.white,
                        ),
                ),
                // SizedBox(width: 0.02.sw),
                Expanded(
                  child: TextFormField(
                    controller: cont.messageController,
                    decoration: InputDecoration(
                      hintText: 'پیام خود را بنویسید',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
