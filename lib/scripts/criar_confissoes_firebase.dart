// Script para adicionar dados das 4 seções da página "Confissões"
// Execute este código no console do Firebase ou através de um script separado

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> criarDocumentosConfissoes() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  try {
    // Primeira Seção - O que é a Confissão
    await firestore.collection('confissoes').doc('primeira_secao').set({
      'titulo': 'O Sacramento da Penitência e da Reconciliação',
      'texto': '''O **Sacramento da Penitência e da Reconciliação**, comumente conhecido como *Confissão*, é um dos sete sacramentos da Igreja Católica. Através dele, recebemos o perdão de Deus para os pecados cometidos após o Batismo.

Este sacramento nos reconcilia com **Deus** e com a **comunidade**, restaurando a graça santificante em nossa alma e fortalecendo nossa vida espiritual.'''
    });
    
    // Segunda Seção - Como se Confessar
    await firestore.collection('confissoes').doc('segunda_secao').set({
      'titulo': 'Como se Confessar',
      'texto': '''### 1. Exame de Consciência
Antes de se confessar, dedique um tempo para refletir sobre suas ações, pensamentos e omissões. Pergunte-se: *"Em que ofendi a Deus e ao próximo?"*

### 2. Arrependimento
Sinta **verdadeiro pesar** pelos pecados cometidos, não apenas pelo medo do castigo, mas principalmente por ter ofendido a Deus, que é amor.

### 3. Propósito de Emenda
Faça o firme propósito de não pecar mais e de evitar as ocasiões próximas de pecado.

### 4. Confissão dos Pecados
Confessar-se ao sacerdote com *sinceridade*, *simplicidade* e *integridade*, dizendo todos os pecados mortais de que se lembra.

### 5. Cumprimento da Penitência
Cumprir a penitência dada pelo confessor como sinal de conversão.'''
    });
    
    // Terceira Seção - Horários e Local
    await firestore.collection('confissoes').doc('terceira_secao').set({
      'titulo': 'Horários de Confissão',
      'texto': '''**Na Igreja Matriz São Lourenço:**

• **Sábados**: 16h às 17h30
• **Domingos**: 7h às 8h e 17h às 18h  
• **Mediante agendamento** com o pároco

**Nas Capelas:**
• Consulte a programação específica de cada capela
• Entre em contato com a secretaria paroquial

*Para casos urgentes ou confissões em horários especiais, entre em contato com a paróquia.*'''
    });
    
    // Quarta Seção - Palavra Bíblica e Orientações
    await firestore.collection('confissoes').doc('quarta_secao').set({
      'titulo': 'Palavra de Jesus',
      'texto': '''> *"Recebei o Espírito Santo. A quem perdoardes os pecados, ser-lhe-ão perdoados; a quem os retiverdes, ser-lhe-ão retidos."*  
> **João 20, 22-23**

**Lembre-se:**
• A confissão é um **encontro pessoal com Jesus**
• O padre representa Cristo e a Igreja
• O **sigilo sacramental** é absoluto
• Não tenha vergonha - Deus já conhece seus pecados e deseja perdoá-lo

Para maiores informações, orientação espiritual ou agendamento de confissão, procure o pároco ou um dos padres colaboradores na secretaria paroquial.'''
    });
    
    print('✅ Todos os documentos das confissões foram criados com sucesso!');
    
  } catch (e) {
    print('❌ Erro ao criar documentos: $e');
  }
}
