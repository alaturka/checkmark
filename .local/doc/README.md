Checkmark
=========

Checkmark, çoktan seçmeli sorular ve bunlarla oluşturulan soru bankalarını modelleyen ve işleyen bir kitaplıktır.

Checkmark'ta soru nesnelerinde bulunan tüm metin alanları Markdown biçimindedir.  Bu sayede sorular HTML, TeX gibi
farklı biçimlerde taranabilmektedir (rendering).  Soru metinlerinde kullanılan temel biçimin Markdown olmasına ilave
olarak Checkmark soru bankalarını ve bu bankalardan üretilen sınavları (quiz) temsil etmek için de Markdown temelli
kolay ayrıştırılabilir bir metinsel içerik biçimi sunar.  Bu özel biçim sayesinde basit metin dosyalarıyla soru
bankalarının ithal edilmesi veya sınavların farklı biçimlerde üretilmesi mümkün olmaktadır.

Terminoloji
-----------

- `Choices`: `A`-`E` arasındaki şıkları taşıyan sözlüğümsü nesne.

- `Question`: Soru gövdesini içeren `stem` alanı ve seçenekleri taşıyan `Choices` nesnesinden oluşan nesne.

- `Item`: Genellikle bir fakat bazen grup halde birden fazla sayıda `Question` içeren nesne.  Grup sorularda grup
  açıklaması `text` alanındadır.

- `Bank`: Bir veya daha fazla sayıda `Item` içeren nesne.

Söz dizimi
----------

Checkmark'ta en tepede yer alan bir `Bank` nesnesi Markdown'dan türetilmiş bir söz dizimiyle temsil edilir.  Bu söz
dizimi YAML biçiminde isteğe bağlı bir "frontmatter" ile başlar.  Checkmark "frontmatter"ı basit bir sözlük olarak kabul
eder ve özel bir şekilde yorumlamaya çalışmaz.  Her `Item` `===` satırlarıyla ayrılır.  `Question` nesnelerinden oluşan
bir `Item`, soru grubuna ait Markdown biçimindeki bir paragrafla başlar ve `---` satırlarıyla ayrılmış halde `Question`
nesnelerini içerir.  Her bir `Question` nesnesi Markdown biçimindeki soru gövdesi (`stem`) ve boş bir satırı takiben
`A)` dizgisiyle başlayan `Choices` nesnesinden oluşur.  `Choices` nesnesinde her şık ayrı bir satırda yazılabileceği
gibi tek paragrafta taranması istenen şıklar için tek satırlık bir biçim kullanılabilir. Bu söz dizimi genel olarak
aşağıda örneklenmektedir:

	---
	anahtar1: değer1
	anahtar2: değer2
	---

	Tek `Question'dan oluşan bir `Item` için Markdown biçiminde soru gövdesi (`stem`).

	A) Markdown biçiminde şık (`choice`)
	B) Markdown biçiminde şık
	C) Markdown biçiminde şık
	D) Markdown biçiminde şık
	E) Markdown biçiminde şık

	===

	Birden fazla `Question`'dan oluşan bir `Item` için Markdown biçiminde grup metni.

	`Item` içindeki ilk `Question`'a ait Markdown biçiminde soru gövdesi.

	A) Markdown biçiminde şık (`choice`)
	B) Markdown biçiminde şık
	C) Markdown biçiminde şık
	D) Markdown biçiminde şık
	E) Markdown biçiminde şık

	---

	`Item` içindeki diğer `Question`'a ait Markdown biçiminde soru gövdesi.

	A) Markdown biçiminde şık (`choice`)
	B) Markdown biçiminde şık
	C) Markdown biçiminde şık
	D) Markdown biçiminde şık
	E) Markdown biçiminde şık

	===

	Tek `Question'dan oluşan bir `Item` için Markdown biçiminde soru gövdesi.

	A) Markdown biçiminde kısa şık B) şık C) şık D) şık E) şık

Söz diziminde aşağıdaki kurallar geçerlidir:

- Soru gövdesi (`stem`) ile şıklar arasında en az bir boş satır bulunur.

- Şıklar satır başında `A)` deseniyle başlar.

- Şıklar tek bir paragrafta veya her şık ayrı bir paragrafta olacak şekilde yazılabilir.

- Öntanımlı olarak ilk şık (`A`) doğrudur.  Alternatif olarak başına `*` konularak (ör `*C)` doğru şık belirtilebilir.
  Dikkat!  Doğru şık için meta bilgi alanı kullanılmaz.

- Bir `Item`'daki ilk metin alanının (grup metni veya tek sorularda soru gövdesi) başında bulunan `/^Q[1-9]*[.)] +/`
  veya `/^[1-9][0-9]*[.)] +/` ön eki soru anahtarı türetmek üzere kaydedilir ve göz ardı edilir.

Banka türleri
-------------

Checkmark'ın merkezinde soru bankası (`Bank`) nesneleri bulunur.  Bu nesneler temelde birer soru bankası olmakla beraber
uygulamada bir bankanın nasıl yorumlanacağı kitaplık tüketicisine bırakılmıştır.  Örneğin kitaplık tüketicisi soru
bankasını bir sınav olarak yorumlayarak farklı PDF kitapçıklar üretebilir.  Bu amaçla kitapçık üretiminde ihtiyaç
duyulacak meta bilgiler "frontmatter" sözlüğünden alınır.  Checkmark olağan senaryolarda sıklıkla karşılaşılabilecek
durumlar için "frontmatter"ın yorumlanma şekline göre 3 farklı soru bankası için yararlı olabilecek işlevler sunar.

1. "Birçok": Çok sayıda `Item` içeren; soru kitapçığı üretiminde veya soru bankalarının aktarımında ("import") yararlı
   olabilecek ön tanımlı tür.  Frontmatter `Bank` ile ilişkilendirilir.

2. "Biraz": Az sayıda (çoğunlukla bir) `Item` içeren ve soruları kendi başına çözümlemekte veya aktarmakta yararlı
   olabilecek basit tür.  Frontmatter her bir `Item` ile (çoğaltılarak) ilişkilendirilir.

3. "Başvuru": Seçilen `Item`'ları değil bunlara ait referansları içeren tür.  İçerik tamamen frontmatter'dan oluşur.

### "Birçok"

Tercihen `.md` uzantılı dosyalarda tutulan bu türde "frontmatter" ile girilen tüm meta bilgiler soru bankasına ait
şekilde yorumlanır.  Girilen meta bilgilerde `meta` anahtarıyla bildirilen sözlük aşağıda anlatıldığı gibi özel olarak
yorumlanır.

- Bir `Item`'da ayrıştırılan soru anahtarı dizgisi sondaki noktalama işaretleri kaldırılarak `meta` sözlüğünde ilgili
  sorunun anahtarı olarak kullanılır.

- `Q` anahtarı tüm `Item`'lara ait genel meta bilgileri temsil eder.  Bir `Item`'ın meta bilgileri üretilirken `Item`'ın
  varsa meta bilgileri bu genel meta bilgiyle birleştirilir.

#### Örnek 1: Basit durum

	---
	name: foo
	description: Lorem ipsum
	---

	Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4


#### Örnek 2: Soru meta bilgileriyle

	---
	name: foo
	description: Lorem ipsum
	meta:
	  Q1: { tags: [foo, bar] }
	  Q2: { tags: [baz, bar] }
	---

	Q1. Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Q2. Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

#### Örnek 3: Genel soru meta bilgileriyle

	---
	name: foo
	description: Lorem ipsum
	meta:
	  Q:  { tags: [foo, bar] }
	---

	Item 1 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

	===

	Item 2 question stem.


	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

#### Örnek 4: Genel ve özel soru meta bilgileriyle

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


### "Biraz"

Bu tür, `Item`'ların tek başına temsil edilmesi için kullanılabilir.  Tercihen `.md` uzantılı veya uzantısız dosyalarda
tutulur.  **Frontmatter'daki sözlük ilgili `Item`'ın meta bilgileri olarak çoğaltılarak kaydedilir.**

#### Örnek 1: Her şık bir paragraf

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

#### Örnek 2: Şıklar tek paragraf

	---
	tags: [foo, bar]
	difficulty: easy
	---

	Stem paragraph.

	A) Correct choice B) Wrong choice 1 C) Wrong choice 2 D) Wrong choice 3	E) Wrong choice 4

#### Örnek 3: Soru grubu

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

### "Başvuru"

YAML veya JSON biçiminde olan bu içerik türünde `Item`'ların kendisi değil referansları verilir.  `Item` referansları
`items` isimli özel bir anahtarda tek bir dizgi veya bir dizi halinde verilebilir.  Referansların çözümlenmesi
gerçeklemeye bırakılmıştır.  Her bir referans `Item` içeren "Biraz" türünde bir `.md` dosyası olarak çözümlenebileceği
gibi, bir veritabanından sorgulama yaparken kullanılabilecek bir `Item` tanımlayıcısı da olabilir.  Kullanılması zorunlu
olan `items` anahtarı dışındaki tüm anahtarlar ilgili `Bank` nesnesinin meta bilgileri olarak kaydedilir.  Bu
anahtarlardan bir kısmı referans çözücü tarafından özel olarak yorumlanabilir.  Örneğin referansları dosya yolu olarak
çözen gerçeklemede aşağıdaki anahtarlar tanımlanabilir.

- `bankdir`: `Item`'ların aranacağı tepe dizin

- `prefix`: Tüm referanslara eklenecek ön ek

- `suffix`: Tüm referanslara eklenecek son ek

Bu içerik türündeki dosyalarda YAML için `.yml`, `.yaml`, JSON için `.json` uzantıları kullanılır.  YAML için özel
olarak `.quiz` dosya uzantısı da kullanılabilir.

#### Örnek 1: Tüm referanslar boşluklarla ayrılmış şekilde tek dizgide

	title: C Programming Final Exam
	date: 2022-06-21
	notes:
	  - Warning 1
	  - Warning 2
	prefix: c/
	suffix: .md

	items: 25 42 19 13

#### Örnek 2: Referans dizisiyle

	title: C Programming Final Exam
	date: 2022-06-21
	notes:
	  - Warning 1
	  - Warning 2
	prefix: c/
	suffix: .md


	items:
	  - 25
	  - 42
	  - 19
	  - 13
