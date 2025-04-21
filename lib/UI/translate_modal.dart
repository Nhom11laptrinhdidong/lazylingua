import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/translate_view_model.dart';

void showCustomModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return  const CustomModalContent();
    },
  );
}

class CustomModalContent extends StatelessWidget {
  const CustomModalContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TranslateViewModel>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '"Lười" Phiên Dịch',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Text('X', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.isEnglishToVietnamese
                              ? 'Tiếng Anh → Tiếng Việt'
                              : 'Tiếng Việt → Tiếng Anh',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: model.toggleDirection,
                          icon: const Icon(Icons.swap_horiz),
                          tooltip: 'Chuyển chiều dịch',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Input
                    TextField(
                      controller: model.inputController,
                      decoration: InputDecoration(
                        labelText: 'Nhập văn bản',
                        border: const OutlineInputBorder(),
                        suffixIcon: model.inputController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: model.clearInput,
                        )
                            : null,
                      ),
                      maxLines: 5,
                      onChanged: (value) => model.notifyListeners(),
                    ),
                    const SizedBox(height: 12),

                    // Translate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: model.translateText,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Dịch', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Output
                    const Text('Bản dịch:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        model.translatedText.isEmpty ? 'Bản dịch sẽ hiện ở đây' : model.translatedText,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
