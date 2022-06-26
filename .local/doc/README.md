Belirtim
========

Terminoloji
-----------

- `Choices`: `A`-`E` arasındaki şıkları taşıyan sözlüğümsü nesne.

- `Question`: Soru gövdesini içeren `stem` alanı ve seçenekleri taşıyan `Choices` nesnesinden oluşan nesne.

- `Item`: Genellikle bir fakat bazen grup halde birden fazla sayıda `Question` içeren nesne.  Grup sorularda grup
  açıklaması `text` alanındadır.

- `Bank`: Bir veya daha fazla sayıda `Item` içeren nesne.

Biçimler
---------

Genel olarak 3 biçim var.

1. `Item` biçimi: Tek bir `Item` içerir.
2. `Bank` biçimi: `Bank` içerir.
3. `Quiz` biçimi: Seçilen `Item`'lardan oluşan bir `Bank`'le temsil edilen sınavlar.

### `Item`

Tüm metin alanlarında (frontmatter hariç) Markdown biçiminin kullanıldığı; isteğe bağlı YAML frontmatter ve `---` ile
ayrılmış sorulardan oluşan biçim.

- Öntanımlı olarak `.md` uzantılı veya uzantısız dosyalarda tutulur.

- Frontmatter'daki sözlük ilgili `Item`'ın meta bilgileri olarak kaydedilir.

- Meta bilgiler isteğe bağlıdır ve içeriğiyle ilgilenilmez.

- Soru gövdesi (`stem`) ile şıklar arasında en az bir boş satır bulunur.

- Şıklar satır başında `A)` deseniyle başlar.

- Şıklar tek bir paragrafta veya her şık ayrı bir paragrafta olacak şekilde yazılabilir.

- Öntanımlı olarak ilk şık (`A`) doğrudur.  Alternatif olarak başına `*` konularak (ör `*C)` doğru şık belirtilebilir.
  Dikkat!  Doğru şık için meta bilgi alanı kullanılmaz.

Örnek 1: Her şık bir paragraf

	---
	tags: [foo, bar]
	difficulty: easy
	---

	Stem paragraph.

	A) Correct choice
	B) Wrong choice 1
	C) Wrong choice 2
	D) Wrong choice 3
	E) Wrong choice 4

Örnek 2: Şıklar tek paragraf

	---
	tags: [foo, bar]
	difficulty: easy
	---

	Stem paragraph.

	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

Örnek 3: Soru grubu

	---
	tags: [foo, bar]
	difficulty: easy
	---

	Group text.

	---

	Question 1 stem paragraph.

	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	---

	Question 2 stem paragraph.

	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

### `Bank`

İsteğe bağlı YAML frontmatter ve `===` ile ayrılmış (frontmatter'sız) `Item`'lardan oluşan soru bankası.

- Öntanımlı olarak `.bank` uzantılı dosyalarda tutulur.

- İsteğe bağlı frontmatter soru bankasıyla ilgili meta bilgileri içerir.

- Meta bilgilerle genel olarak ilgilenilmez.  Özel olarak meta bilgilerde bulunan `items` alanı ilgili `Item` anahtarı
  ve buna karşı gelen meta bilgilerden oluşan bir alt sözlüktür.

- Bir `Item`'daki ilk metin alanının (Grup metni veya tek sorularda soru gövdesi) başında bulunan `/^Q[1-9]*[.)] +/`
  veya `/^[1-9][0-9]*[.)] +/` ön eki soru anahtarı türetmek üzere kaydedilir ve göz ardı edilir.

- Bir `Item`'da ayrıştırılan ön ekten gelen dizgi sondaki noktalama işaretleri kaldırılarak meta bilgilerdeki `items`
  sözlüğünde ilgili sorunun anahtarı olarak kullanılır.

- `Q` anahtarı tüm `Item`'lara ait genel meta bilgileri temsil eder.  Bir `Item`'ın meta bilgileri üretilirken `Item`'ın
  varsa meta bilgileri bu genel meta bilgiyle birleştirilir.

Örnek 1: Basit durum

	---
	name: foo
	description: Lorem ipsum
	---

	Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4


Örnek 2: Soru meta bilgileriyle

	---
	name: foo
	description: Lorem ipsum
	items:
	  Q1: { tags: [foo, bar] }
	  Q2: { tags: [baz, bar] }
	---

	Q1. Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Q2. Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

Örnek 2: Genel soru meta bilgileriyle

	---
	name: foo
	description: Lorem ipsum
	items:
	  Q:  { tags: [foo, bar] }
	---

	Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4


Örnek 3: Genel ve özel soru meta bilgileriyle

	---
	name: foo
	description: Lorem ipsum
	items:
	  Q:  { tags: [foo, bar] }
	  Q2: { tags: [baz, bar] }
	---

	Q1. Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Q2. Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4


### Inline `Quiz`

Zorunlu YAML frontmatter ve `Item`'ların açık şekilde girildiği sınav dosyası.  Bu biçim `Bank` ile aynıdır, tek fark
frontmatter'ın zorunlu olmasıdır.

- Öntanımlı olarak `.md` uzantılı dosyalarda tutulur.

- Frontmatter genel olarak sınavla ilgili meta bilgileri tutar ve içeriği sadece şablon tarafından yorumlanır.

Örnek:

	---
	title: C Programming Final Exam
	date: 2022-06-21
	notes:
	  - Warning 1
	  - Warning 2
	---

	Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4


### `Quiz`

Zorunlu YAML frontmatter ve `Item` referanslarından oluşan sınav dosyası.  Bu biçim "Inline `Quiz`"'e dönüştürülecek bir
biçimdir.

- Öntanımlı olarak `.quiz` uzantılı dosyalarda tutulur.

- `Item`'lar boşluk veya satır sonlarıyla ayrılmış dosya ismi referanslarıyla belirtilir.

- Refere edilen dosyalar sırasıyla komut satırından, ortam değişkeninden ve frontmatter'da isteğe bağlı olarak
  tanımlanan `library` dizini içinde aranır.  Arama sırasında meta bilgilerdeki `prefix` alanı dosya adının başına
  eklenir.

- Uzantı verilmeyen dosya referansları arama sırasında bulunamamışsa bir de `.md` uzantısı eklenerek aranır.


Örnek:

	---
	title: C Programming Final Exam
	date: 2022-06-21
	notes:
	  - Warning 1
	  - Warning 2
	prefix: c/
	---

        25 42 19 13
