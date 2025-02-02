import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo{
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);
  Future<bool> get isConnected async{
    final connectivityResult= await connectivity.checkConnectivity();
    final isConnected=connectivityResult[0]!=ConnectivityResult.none;
    return isConnected;
  }
}