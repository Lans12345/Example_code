import 'package:flutter/material.dart';

import '../widgets/text_widget.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextRegular(
            text: 'Terms and Conditions', fontSize: 18, color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              20,
              10,
              20,
            ),
            child: TextRegular(
                text:
                    "Terms and Conditions\n\n\n1. Introduction These Website Standard Terms and Conditions written on this webpage shall manage your use of our mobile application, The Serve (the 'App'). By accessing or using the App, you agreed to be bound by these terms and conditions. If you disagree with any part of these terms and conditions, you must not use the App.\n\n2. License to use the App We grant you a revocable, non-exclusive, non-transferable, limited license to download, install and use the App solely for your personal, non-commercial purposes strictly in accordance with the terms of this Agreement.\n\n3. Restrictions You agree not to, and you will not permit others to: - license, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the App or make the App available to any third party. - modify, translate, make derivative works of, disassemble, decompile, reverse compile or reverse engineer any part of the App. - use the App for any illegal purpose, or in violation of any local, state, national, or international law. - remove, alter, or obscure any proprietary notice (including any notice of copyright or trademark) of The Serve or its affiliates, partners, suppliers or the licensors of the App.\n\n4. Intellectual Property The App and all intellectual property rights in and to the App (including but not limited to any titles, computer code, themes, objects, characters, character names, stories, dialog, catch phrases, locations, concepts, artwork, character inventories, structural or landscape designs, animations, sounds, musical compositions, audio-visual effects, methods of operation, moral rights, any related documentation, and 'applets' incorporated into the App) are owned by [COMPANY NAME] or its licensors. The App is protected by copyright, trademark, and other intellectual property laws.\n\n5. Termination This Agreement is effective until terminated by you or The Serve. Your rights under this Agreement will terminate automatically without notice from The Serve if you fail to comply with any term(s) of this Agreement. Upon the termination of this Agreement, you shall cease all use of the App, and destroy all copies, full or partial, of the App.\n\n6. Disclaimer of Warranties The App is provided on an 'as is' and 'as available' basis. The Serve and its affiliates, partners, and suppliers make no representation or warranties of any kind, express or implied, as to the operation of the App or the information, content, materials, or products included on the App. To the full extent permissible by applicable law, The Serve and its affiliates, partners, and suppliers disclaim all warranties, express or implied, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose. The Serve and its affiliates, partners, and suppliers will not be liable for any damages of any kind arising from the use of the App, including, but not limited to, direct, indirect, incidental, punitive, and consequential damages.\n\n7. Governing Law This Agreement shall be governed by and construed in accordance with the laws of the State of [STATE], and you hereby consent to the exclusive jurisdiction and venue of courts in Philippines in all disputes arising out of or relating to the use of the App.\n\n8. Entire Agreement",
                fontSize: 14,
                color: Colors.black),
          ),
        ]),
      ),
    );
  }
}
