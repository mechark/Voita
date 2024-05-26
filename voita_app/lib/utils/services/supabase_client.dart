import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClient {
  static const String _url = "https://uifwsbwtyelaemtwqpnr.supabase.co";
  static const String _anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpZndzYnd0eWVsYWVtdHdxcG5yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYwNjA0MzgsImV4cCI6MjAzMTYzNjQzOH0.M-p_s6XbA3lB74l5fOOqrXd_9cshfp9YwAu_oDU6tp4";

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
    );
  }
}