import 'package:android_popular_git_repos/core/constants/app_constants.dart';
import 'package:android_popular_git_repos/core/network/network_info.dart';
import 'package:android_popular_git_repos/core/theme/app_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 late NetworkInfo networkInfo;
 bool isConnected=false;
  @override
  void initState() {

    super.initState();
    networkInfo=NetworkInfo(Connectivity());
    checkConnection();
  }
  Future<void> checkConnection() async{
    isConnected= await networkInfo.isConnected;
    setState(() {
      isConnected=isConnected;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Popular GitRepos'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Hello World'),
              Text(isConnected?'Connected':'Not Connected'),
              Text(networkInfo.isConnected.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

