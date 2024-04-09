import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Two Tabs Example'),
          bottom: TabBar(
            tabs: [
             ElevatedButton(onPressed: (){}, child: Text("sdfsd")),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // Use the full height of the screen
            child: TabBarView(
              children: [
                // Content of Tab 1
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Content of Tab 1'),
                ),
                // Content of Tab 2
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Content of Tab 2'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
