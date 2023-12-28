## Aplikacja mobilna bankowa

1. **Hosting API (i aplikacji webowej) na publicznym serwerze** - jest GCP
2. **Kompatybilność aplikacji mobilnej i łączność z API** - jest
3. **UI - spójność, HQ ikony, długie odpowiedzi UI z ikonami oczekiwania, walidacja danych** - jest
4. **Język, tryby jasności** - polski/angielski, tryb jasny/ciemny
5. **OAuth Social login** - jest logowanie przez Google, rejestracji brak ze wzgl. na charakterystykę projektu
(rejestracja w banku)
6. **Dostęp do zasobów sprzętowych** - jest gps do pokazania najbliższego oddziału banku
7. **Wspólna warstwa serwisów dla aplikacji mobilnej i web** - jest api/

---

Aplikacja dostępna jest po adresem [https://gb24.gcp.jewusiak.pl](https://gb24.gcp.jewusiak.pl)

---

## Funcjonalności
Aplikacja pozwala na podstawowe funkcje bankowości mobilnej:
1. Rejestracja w banku
2. Logowanie hasłem maskowanym / via Google
3. Wysłanie przelewu
4. Przeglądanie historii przelewów
5. Sprawdzenie danych w systemie - PESEL, nr dowodu
6. Sprawdzenie danych karty płatniczej
7. Wrażliwe dane są szyfrowane w bazie
8. Zmiana języka, wyglądu UI
9. Zmiana hasła po zalogowaniu
10. Przywracanie hasła linkiem 