import 'package:LCI/custom-components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampaignNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 35, 30, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeadings(
                text: 'Campaign',
                metaText: 'Haven\'t join any Campaign yet?',
              ),
              Padding(padding: EdgeInsets.all(20)),
              PrimaryButton(
                text: 'Create New Campaign',
                color: Color(0xFF299E45),
                textColor: Colors.white,
                onClickFunction: () {},
              ),
              Padding(padding: EdgeInsets.all(25)),
              Text(
                'OR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6E6E6E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(padding: EdgeInsets.all(25)),
              PrimaryButton(
                text: 'Join Campaign',
                color: Color(0xFF170E9A),
                textColor: Colors.white,
                onClickFunction: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SetupCampaign()))
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupCampaign extends StatefulWidget{

}

class _SetupCampaignState extends State<SetupCampaign>{
  
}