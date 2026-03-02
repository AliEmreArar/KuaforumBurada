import 'package:flutter/material.dart';

class LegalConsentCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const LegalConsentCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: isChecked,
      validator: (value) {
        if (value != true) {
          return 'Devam etmek için şartları kabul etmelisiniz.';
        }
        return null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (val) {
                    onChanged(val);
                    state.didChange(val);
                  },
                  activeColor: const Color(0xFFEA004B),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Show terms dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Kullanıcı Sözleşmesi ve KVKK'),
                          content: const SingleChildScrollView(
                            child: Text(
                              'Burada yasal metinler, KVKK aydınlatma metni ve kullanıcı sözleşmesi yer alacaktır. '
                              'Kullanıcı bu metni okuyup onaylamalıdır.\n\n'
                              '1. Taraflar...\n'
                              '2. Konu...\n'
                              '3. Hak ve Yükümlülükler...',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Kapat'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Kullanıcı Sözleşmesi\'ni ve KVKK metnini okudum, onaylıyorum.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
