# Tutorial 3 & 5

| Index |
| --- |
| [Tutorial 3](#tutorial-3---introduction-to-game-programming) |
| [Tutorial 5](#tutorial-5---assets-creation--integration) |

## Tutorial 5 - Assets Creation & Integration

...

## Tutorial 3 - Introduction to Game Programming

Final Commit: `47c76df`

### Proses Pengerjaan: Fitur Lanjutan

Pertama saya melakukan *breakdown* dari ketiga fitur lanjutan tersebut untuk memahaminya lebih lanjut:

- `Double Jump`: *Jump* tambahan ketika di udara -> Perlu cek apabila karakter memiliki status Double jump
- `Dashing`: *Speed boost* (seperti *sprinting*) ketika melakukan *double tap* input arah yang sama -> Perlu check input *double tap*
- `Crouching`: *Slow debuff*, bisa melewati area yang lebih sempit

Selanjutnya, saya melakukan eksperimentasi ketiga fitur lanjutan tersebut.
Fitur `Double Jump` bisa dibilang lumayan mudah karena hanya melakukan cek `is_on_ground` karakter pemain.
Fitur `Crouching` juga hanya melakukan cek *state* input.
Namun kode saya di tahap ini sudah lumayan berantakan, sehingga dilakukan *refactoring* kode movement pemain.

Setelah itu, saya menggunakan adaptasi dari forum post [ini](https://godotforums.org/d/35106-is-there-a-simple-solution-for-a-double-tap/9)
untuk menerapkan *double tap* yang diperlukan fitur `Dashing`.

### Proses Pengerjaan: Polishing

Untuk polishing, saya melakukan:

- Mengubah *sprite* karakter pemain dari *placeholder* pesawat menjadi manusia
- Menyesuaikan *sprite* karakter dengan arah yang dituju (menggunakan flip horizontal)
- Naiive *sprite* animations dengan load texture:
  - `idle` ketika tidak ada input
  - `crouch` ketika sedang `Crouching`
  - `jump` ketika sedang lompat/`Double Jump`
  - `walk` ketika sedang bergerak kanan/kiri
- Remapping input supaya lebih nyaman untuk lebih banyak pemain
  - `move_right`: `D`, `ArrowRight`, `DPadRight`
  - `move_left`: `A`, `ArrowLeft`, `DPadLeft`
  - `move_jump`: `Spacebar`, `ArrowUp`, `DPadUp`
  - `move_crouch`: `Ctrl`, `ArrowDown`, `DpadDown`
