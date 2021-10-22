import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import "package:meta/meta.dart";

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url
  });

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url
  });
}

// Como não podemos instanciar classe abstrata, utilizamos o Mockito
// Para intanciar ela e podermos utilizar
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call HttpClient with correct URL', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url); //System Under Test
    // (AAA Pattern)
    // Arrange = Organizar | Objetos devem ser criados, mocks setup
    // Act     = Ato       | Invocar o método que está sendo testado
    // Assert  = Asserto   | Verifica se as expectativas foram atendidas

    await sut.auth();

    verify(httpClient.request(url: url));
  });
}