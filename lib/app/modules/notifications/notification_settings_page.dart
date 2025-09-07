import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:paroquia_sao_lourenco/app/shared/services/push_notification_service.dart';

/// Página para configuração de notificações push
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final _pushService = Modular.get<PushNotificationService>();
  String? _playerId;
  bool _hasPermission = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationStatus();
  }

  /// Carrega o status atual das notificações
  Future<void> _loadNotificationStatus() async {
    setState(() => _isLoading = true);
    
    try {
      final permission = await _pushService.hasPermission();
      final playerId = await _pushService.getPlayerId();
      
      setState(() {
        _hasPermission = permission;
        _playerId = playerId;
      });
    } catch (e) {
      debugPrint('Erro ao carregar status: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Solicita permissão para notificações
  Future<void> _requestPermission() async {
    setState(() => _isLoading = true);
    
    try {
      await _pushService.initialize();
      await _loadNotificationStatus();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão para notificações solicitada!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao solicitar permissão: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Notificação'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status das Notificações',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          _buildStatusRow(
                            'Permissão',
                            _hasPermission ? 'Concedida' : 'Negada',
                            _hasPermission ? Colors.green : Colors.red,
                          ),
                          const SizedBox(height: 8),
                          _buildStatusRow(
                            'Player ID',
                            _playerId ?? 'Não disponível',
                            _playerId != null ? Colors.blue : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Actions
                  Text(
                    'Configurações',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  
                  if (!_hasPermission) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _requestPermission,
                        icon: const Icon(Icons.notifications),
                        label: const Text('Ativar Notificações'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue[600]),
                                const SizedBox(width: 8),
                                Text(
                                  'Sobre as Notificações',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Ative as notificações para receber:\n\n'
                              '• Avisos importantes da paróquia\n'
                              '• Lembretes de missas e eventos\n'
                              '• Comunicados dos ministérios\n'
                              '• Novidades e informações relevantes',
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green[600]),
                                const SizedBox(width: 8),
                                Text(
                                  'Notificações Ativadas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Você receberá notificações sobre eventos, missas e comunicados importantes da Paróquia São Lourenço.',
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
