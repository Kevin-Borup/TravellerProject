import 'dart:convert';

import 'package:traveller_app/data/api/web/token_web_http_service.dart';
import 'package:traveller_app/data/models/login.dart';
import 'package:traveller_app/data/models/train_route.dart';
import 'package:traveller_app/data/models/ticket.dart';
import 'package:traveller_app/interfaces/i_api_traveller.dart';

import 'package:http/http.dart';
import '../../models/search.dart';

class TravellerWebDataHttp implements IApiTraveller {

  final Client _httpClient = Client();
  late final TokenWebHttpService _httpTokenService;
  late bool _isHttpInitialized = false;

  final String _baseURL = "https://10.108.149.13:3000/";

  final String _routesCtr = "routes/";
  final String _allRouteEndPoint = "all";
  final String _searchRoutesEndPoint = "search";

  final String _ticketsCtr = "tickets/";
  final String _allTicketsEndPoint = "all";
  final String _purchaseTicketEndPoint = "purchase";

  Future<void> _initializeHttpService() async {
    if (_isHttpInitialized) return;
    _httpTokenService = TokenWebHttpService(_httpClient, _baseURL);
    _isHttpInitialized = true;
  }

  @override
  Future<bool> checkLogin(Login login) async {
    return await _httpTokenService.getRemoteAccessToken(login, false);
  }

  @override
  Future<bool> register(Login login) async {
    return await _httpTokenService.getRemoteAccessToken(login, true);
  }

  @override
  Future<List<TrainRoute>> getAllRoutes() async {
    await _initializeHttpService();

    Uri requestUri = Uri.parse(_baseURL + _routesCtr + _allRouteEndPoint);
    Map<String, String> requestHeader = {
      "Content-Type": "application/json",
    };

    var response = await _httpClient.get(
        requestUri,
        headers: requestHeader);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<TrainRoute> trainRoutes = (json.decode(responseBody) as List)
          .map((i) => TrainRoute.fromJson(i)).toList();

      return trainRoutes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          '[ERROR] Failed to get - response code: ${response.statusCode}');
    }
  }

  @override
  Future<List<TrainRoute>> getRelevantRoutes(Search search) async {
    await _initializeHttpService();

    Uri requestUri = Uri.parse(_baseURL + _routesCtr + _searchRoutesEndPoint);
    Map<String, String> requestHeader = {
      "Content-Type": "application/json",
    };

    var response = await _httpClient.post(
        requestUri,
        headers: requestHeader,
        body: json.encode(search.toJson()),
        encoding: Encoding.getByName("UTF-8"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<TrainRoute> trainRoutes = (json.decode(responseBody) as List)
          .map((i) => TrainRoute.fromJson(i)).toList();

      return trainRoutes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          '[ERROR] Failed to get - response code: ${response.statusCode}');
    }
  }

  @override
  Future<List<Ticket>> getAllTickets() async {
    await _initializeHttpService();
    String token = await _httpTokenService.getLocalAccessToken();

    Uri requestUri = Uri.parse(_baseURL + _ticketsCtr + _allTicketsEndPoint);
    Map<String, String> requestHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await _httpClient.get(
        requestUri,
        headers: requestHeader);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      String responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<Ticket> tickets = (json.decode(responseBody) as List)
          .map((i) => Ticket.fromJson(i)).toList();

      return tickets;
    } else if (response.statusCode == 401) {
      // login again
      throw Exception('[ERROR] Unauthorized');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          '[ERROR] Failed to get - response code: ${response.statusCode}');
    }
  }

  @override
  Future<void> purchaseTicket(String routeId) async {
    await _initializeHttpService();
    String token = await _httpTokenService.getLocalAccessToken();

    Uri requestUri = Uri.parse(_baseURL + _ticketsCtr + _purchaseTicketEndPoint);
    Map<String, String> requestHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await _httpClient.post(
        requestUri,
        headers: requestHeader,
        body: json.encode(routeId),
        encoding: Encoding.getByName("UTF-8"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response

      return;
    } else if (response.statusCode == 401) {
      // login again
      throw Exception('[ERROR] Unauthorized');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          '[ERROR] Failed to get - response code: ${response.statusCode}');
    }
  }
}