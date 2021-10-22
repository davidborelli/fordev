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
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method
  });
}

// Como não podemos instanciar classe abstrata, utilizamos o Mockito
// Para intanciar ela e podermos utilizar
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url); //System Under Test
  });

  test('Should call HttpClient with correct URL', () async {

    // (AAA Pattern)
    // Arrange = Organizar | Objetos devem ser criados, mocks setup
    // Act     = Ato       | Invocar o método que está sendo testado
    // Assert  = Asserto   | Verifica se as expectativas foram atendidas

    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'post'
    ));
  });
}