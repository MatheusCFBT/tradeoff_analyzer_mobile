[![CI](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/ci.yml/badge.svg)](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/ci.yml)

[![CD](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/cd.yml/badge.svg)](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/actions/workflows/cd.yml)


# Tradeoff Analyzer Mobile

Aplicação Flutter para organizar decisões e seus trade-offs. O projeto está em
desenvolvimento e atualmente permite definir o tema de uma decisão e registrar
argumentos favoráveis.

A camada de dados está em construção; persistência e comparação final ainda não
estão implementadas.

## Tecnologias e arquitetura

- Flutter e Dart, com interface Material Design.
- MVVM com `ChangeNotifier` e injeção de dependências com GetIt.
- Organização por funcionalidade, com repositórios e fontes de dados separados.
- Dependências Firebase para integração com serviços de autenticação e dados.

```text
lib/
├── dependency_injection/   # Registro de dependências
├── data_source/            # Fontes de dados
├── features/
│   ├── comparison/         # Fluxo de comparação de decisões
│   └── shared/             # Componentes reutilizáveis
└── routers/               # Navegação
```

## Desenvolvimento local

### Requisitos

- Flutter 3.47.1, versão utilizada no CI.
- JDK 17 e Android SDK para builds Android.
- Dispositivo Android ou emulador para executar o aplicativo.

```bash
git clone https://github.com/MatheusCFBT/tradeoff_analyzer_mobile.git
cd tradeoff_analyzer_mobile
flutter pub get --enforce-lockfile
```

O build Android utiliza o plugin Google Services e requer
`android/app/google-services.json`. Para desenvolvimento com Firebase, esse arquivo
deve corresponder ao aplicativo Android `com.example.tradeoff_analyzer_mobile`.

Para validar a compilação sem configurar um projeto Firebase:

```bash
cp .github/firebase/google-services.example.json android/app/google-services.json
flutter run
```

A configuração de exemplo não conecta o aplicativo a um projeto Firebase real.
O arquivo de configuração local está excluído do controle de versão.

### Verificações

```bash
dart format lib test
flutter analyze --fatal-infos
flutter test --coverage
flutter build apk --release
```

## Integração e entrega contínuas

| Workflow | Gatilhos | Responsabilidade |
| --- | --- | --- |
| [CI](.github/workflows/ci.yml) | PRs para `main`, pushes na `main` e execução manual | Formatação, lint, testes, segurança e build Android |
| [CD](.github/workflows/cd.yml) | Tags `vX.Y.Z` | Validação da versão, execução do CI e publicação do APK |

O CI verifica vulnerabilidades dos pacotes Dart com OSV-Scanner e aceitação
insegura de certificados TLS com uma regra Semgrep. Essa análise não cobre todas
as classes de vulnerabilidades nem dependências nativas transitivas. Falhas nos
checks impedem o build e a publicação. Cobertura, relatórios e APKs ficam
disponíveis nos artefatos das execuções.

Builds de validação usam a configuração Firebase de exemplo, inclusive em PRs de
forks. Para releases, o CD requer o secret de repositório `GOOGLE_SERVICES_JSON`,
contendo a configuração Android Firebase completa. A publicação utiliza o
`GITHUB_TOKEN` fornecido pelo GitHub Actions.

### Releases

A versão segue o formato `X.Y.Z+N` no `pubspec.yaml`. Após a atualização chegar à
`main`, uma tag correspondente, como `v1.0.0`, dispara o CD. A tag deve indicar um
commit pertencente ao histórico da `main`; prereleases não são aceitas.

O número de build é atribuído pela execução do workflow. O APK é publicado nos
[GitHub Releases](https://github.com/MatheusCFBT/tradeoff_analyzer_mobile/releases)
com notas automáticas. A assinatura atual é de debug, destinada a testes, e pode
exigir reinstalação entre builds. Distribuição em lojas não está configurada.

A pipeline atualmente contempla Android. Um job macOS pode ser acrescentado ao
CI reutilizável para incluir builds iOS.