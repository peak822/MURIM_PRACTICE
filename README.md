# 🥋 MURIM PRACTICE (บันทึกการฝึกตนและบ่มเพาะวรยุทธ์)

> **Gamified Habit & Study Tracker Application** ในธีมกำลังภายใน (Oriental Wuxia / Cultivation) พัฒนาด้วย Flutter & Dart พร้อมสถาปัตยกรรม **Offline-First Reactive UI** และกราฟยันต์แปดทิศ (Bagua Radar Chart)

## การฝึกสามเส้นทาง (MVP)

- **Mind:** จับเวลาสมาธิจากเวลาฝึกจริง พัก/ฝึกต่อได้ บันทึก session และ reflection ได้เมื่อครบเวลาที่เลือก
- **Body:** เลือกรูทีน บันทึกเซ็ต จำนวนครั้ง/เวลาของแต่ละท่าและ variation ที่ใช้จริง เซสชันที่ไม่มีเซ็ตไม่รับ Qi
- **Knowledge:** Focus Session ตั้งหัวข้อและเวลา focus/พัก บันทึกข้อสรุปหรือคำถามทบทวน 1–3 ข้อ เวลาพักไม่รวมในเวลาศึกษา สามารถผูก mission เพื่อรับรางวัลครั้งเดียว

Qi, XP และ realm เป็นตัวชี้วัดความคืบหน้าในแอป ไม่ใช่การวัดสมรรถภาพ สุขภาพจิต หรือความสามารถในการเรียนรู้ ควรพักและเลือกระดับการฝึกที่เหมาะกับตนเอง

ข้อมูลทั้งหมดเก็บใน Hive บนเครื่อง ผู้ใช้ส่งออก JSON schema v2 จาก Settings เพื่อสำรองข้อมูล ซึ่งรวม mission, stats, logs, training records, practice sessions และ reward ledger การนำเข้า v1 ยังรองรับ แต่ v1 ไม่มีประวัติฝึกกาย/ฝึกจิต จึงไม่สามารถกู้ข้อมูลที่ไม่เคยอยู่ในไฟล์นั้นได้ การ restore จะแทนที่ข้อมูลปัจจุบัน ควร export สำเนาก่อน ระบบเก็บ snapshot เพื่อกู้คืนหาก restore ถูกขัดจังหวะ รางวัลที่บันทึกแล้วจะไม่ถูกเพิ่มซ้ำเมื่อเปิดแอปใหม่

เซสชันที่ยังไม่กดบันทึกจะหยุดเมื่อปิดแอปและไม่ได้รางวัล หากแอปปิดระหว่างบันทึกเซสชันที่ทำครบแล้ว ระบบจะตรวจรายการค้างและกู้รางวัลเพียงครั้งเดียวเมื่อเปิดใหม่ การลบรายการประวัติฝึกกายไม่หัก Qi/XP ที่เคยได้รับ

ภารกิจรายวันยังใช้กฎ streak เดิมตามวันที่ท้องถิ่น ส่วน Font จาก `google_fonts` อาจต้องใช้เครือข่ายในการดึงครั้งแรกหากไม่มี cache; ข้อมูลการฝึกและการสำรองยังทำงานแบบ local

เมื่อยกเลิกภารกิจที่ทำสำเร็จ ระบบหักรางวัลตามยอดที่บันทึกไว้จริง และหากทำใหม่จะคืนยอดเดิมหนึ่งครั้ง ภารกิจเก่าที่ไม่มีบันทึกรางวัลจะไม่ให้ยกเลิกจากหน้าภารกิจ เพราะไม่สามารถหัก Qi/XP ให้ตรงกับยอดเดิมได้

---

## 📖 สารบัญ (Table of Contents)
- [ข้อมูลโครงการสำหรับสร้างสไลด์นำเสนอ](Murim_Practice_Presentation_Brief.md)
- [ภาพรวมโครงการ (Project Overview)](#-ภาพรวมโครงการ-project-overview)
- [เทคโนโลยีและแพ็กเกจหลัก (Tech Stack)](#-เทคโนโลยีและแพ็กเกจหลัก-tech-stack)
- [ฟีเจอร์เด่น (Features Showcase)](#-ฟีเจอร์เด่น-features-showcase)
- [สถาปัตยกรรมระบบและการไหลของข้อมูล (System Architecture & Data Flow)](#-สถาปัตยกรรมระบบและการไหลของข้อมูล-system-architecture--data-flow)
- [สูตรคำนวณและโมเดลการบ่มเพาะ (Cultivation & Gamification Formulas)](#-สูตรคำนวณและโมเดลการบ่มเพาะ-cultivation--gamification-formulas)
- [การทดสอบระบบ (Automated Unit Tests)](#-การทดสอบระบบ-automated-unit-tests)
- [แนวทางการพัฒนาต่อยอด (Future Roadmap)](#-แนวทางการพัฒนาต่อยอด-future-roadmap)
- [ลิขสิทธิ์และการอ้างอิง (Licensing & Credits)](#-ลิขสิทธิ์และการอ้างอิง-licensing--credits)

---

## 🌟 ภาพรวมโครงการ (Project Overview)

**MURIM PRACTICE** เป็นแอปพลิเคชันจัดการการเรียนรู้และพัฒนาตนเอง (Habit & Task Tracker) ที่นำแนวคิด **Gamification** มาผนวกกับเสน่ห์ของโลกกำลังภายใน เปลี่ยนกิจกรรมในชีวิตประจำวัน เช่น การอ่านหนังสือ การเขียนโค้ด การออกกำลังกาย และการทำสมาธิ ให้กลายเป็นการสะสมพลังปราณ (Qi), ทะลวงจุดชีพจร, และเลื่อนขั้นขอบเขตยุทธภพสู่ระดับ "เซียนสวรรค์ไร้พ่าย"

### จุดเด่นสำคัญ:
1. **ธีมกำลังภายในระดับพรีเมียม (Oriental Wuxia Dark Mode)**: โทนสีหยกมังกร (Jade), ทองคำศักดิ์สิทธิ์ (Imperial Gold), และปราณฟ้า (Qi Cyan) บนพื้นหลังกระดาษคัมภีร์โบราณและหมึกจีน
2. **ยันต์แปดทิศสเตตัสวรยุทธ์ (Reactive Bagua Radar Chart)**: กราฟเรดาร์ 6 มิติที่อัปเดตสเตตัสแบบ Reactive ทันทีที่มีการทำภารกิจสำเร็จ
3. **ระบบทะลวงด่าน 20 ระดับ (Cultivation Realms & Breakthrough Dialog)**: สัมผัสความตื่นเต้นเมื่อพลัง Qi สะสมถึงจุดสูงสุดและปลดล็อกขอบเขตใหม่
4. **ห้องปิดด่านฝึกตน (Secluded Focus Timer)**: ระบบจับเวลาสมาธิและโฟกัสพร้อมแอนิเมชันลูกแก้วลมปราณหมุนเวียน
5. **เก็บข้อมูลแบบ local-first ด้วย Hive**: ประวัติการฝึกและสถิติเก็บบนเครื่อง รองรับ Windows Desktop และ Mobile; ดูหมายเหตุเรื่อง Font ด้านบน

---

## 🛠️ เทคโนโลยีและแพ็กเกจหลัก (Tech Stack)

| ส่วนประกอบ | เทคโนโลยี / Package | วัตถุประสงค์ |
|---|---|---|
| **Framework** | Flutter 3.44+ / Dart 3.12+ | Cross-Platform (Desktop & Mobile) |
| **State Management** | `provider` (^6.1.2) | Reactive State Management & Separation of Concerns |
| **Local Database** | `hive` (^2.2.3) & `hive_flutter` | NoSQL Embedded Storage ทำงานรวดเร็ว ไม่พึ่งพาเซิร์ฟเวอร์ |
| **Data Visualization** | `fl_chart` (^0.69.0) | สร้างกราฟ Radar Chart แบบไดนามิก |
| **Typography** | `google_fonts` (^6.2.1) | ฟอนต์ Cinzel, Noto Sans Thai, Noto Serif Thai |
| **Utilities** | `uuid`, `intl`, `path_provider` | Unique IDs, Date/Time formatting, Local path handling |

---

## ⚔️ ฟีเจอร์เด่น (Features Showcase)

### 1. 🏛️ หอฝึกตน (Cultivation Pagoda Dashboard)
- **Realm Hero Banner**: แสดงระดับขอบเขตลมปราณปัจจุบัน (ขั้นที่ 1 - 20) แถบพลัง Qi และจำนวน Qi ที่ต้องการเพื่อทะลวงสู่ขั้นถัดไป
- **Bagua Radar Chart**: กราฟใยแมงมุม 6 ด้าน (พลังกาย, สติปัญญา, วรยุทธ์, สมาธิ, วินัย, ลมปราณรวม)
- **Daily Streak Flame**: ระบบไฟนับวันฝึกตนต่อเนื่อง พร้อมโบนัส Qi สูงสุด +30%
- **4 Martial Disciplines**: สรุปความก้าวหน้ารายสายวิชา (บ่มเพาะกายา, ฝึกจิตปัญญา, ฝึกปรือวรยุทธ์, ขัดเกลาปราณ)

### 2. 📜 หอเทียบภารกิจสำนัก (Sect Missions)
- สร้าง แก้ไข และลบเทียบภารกิจ พร้อมระบบคำนวณ Qi ล่วงหน้า (XP Preview)
- จัดหมวดหมู่ 4 สายวิชา พร้อมระดับความท้าทาย 4 ขั้น (ระดับต่ำ, กลาง, สูง, เซียน)
- ระบบค้นหาและตัวกรองสถานะ (ทั้งหมด, ยังไม่เสร็จ, สำเร็จแล้ว)
- กดเช็กภารกิจพร้อมแอนิเมชันแสงปราณ และการแจ้งเตือนทันที

### 3. 🧘 ห้องปิดด่านฝึกตน (Secluded Cultivation Timer)
- นาฬิกาจับเวลาโฟกัสและสมาธิ (10, 20, 25, 45, 60 นาที)
- แอนิเมชันลูกแก้วลมปราณหายใจ (Breathing Qi Orb) ช่วยกำหนดจังหวะสมาธิ
- รับพลังปราณบริสุทธิ์สะสมเข้าสู่สายวิญญาณโดยตรง

### 4. 📚 หอบันทึกคัมภีร์ยุทธภพ (Hall of Records / Chronicle)
- บันทึกประวัติเหตุการณ์สำคัญ เช่น การสำเร็จภารกิจ, การทะลวงด่านใหญ่, และสถิติการปิดด่าน
- สรุปตัวชี้วัดความสำเร็จทั้งหมดของจอมยุทธ์
- ปฏิทินการฝึกตนแสดง 52 สัปดาห์ล่าสุดแบบอ่านอย่างเดียว นับหนึ่งครั้งต่อกิจกรรมที่สำเร็จจริง และกรอง Mind / Body / Knowledge พร้อมประวัติด้านล่าง ตารางเลื่อนแนวนอนได้บนมือถือและเดสก์ท็อป ปุ่ม Today กลับไปสัปดาห์ล่าสุด และรายละเอียดวันแสดงเวลาและ Qi เฉพาะที่มีบันทึกจริง
- ลำดับแหล่งข้อมูลของปฏิทิน: reward event ต้นฉบับที่ credited มาก่อน โดยรวม Mission ที่เชื่อม Focus ผ่าน occurrence ID; training record หรือ practice session สถานะ completed เป็นข้อมูลสำรองเมื่อไม่มี event; log รุ่นเก่านับเฉพาะรายการสำเร็จที่ระบุชัด และจับคู่ log ยกเลิกภารกิจตามชื่อกับหมวดก่อนนับ ไม่รวม breakthrough, streak, pending หรือการ undo/redo เป็นกิจกรรมใหม่ วันที่อิงวันท้องถิ่นของเวลาสำเร็จ ข้อมูล log รุ่นเก่าที่ไม่มี ID ผูกกับกิจกรรมอาจจับคู่ข้ามรายการชื่อซ้ำกันไม่ได้อย่างสมบูรณ์

---

## 🏗️ สถาปัตยกรรมระบบและการไหลของข้อมูล (System Architecture)

แอปพลิเคชันใช้สถาปัตยกรรมแบบ **Clean Layered Architecture** ควบคู่กับ **Provider Pattern**:

```
lib/
├── core/                       # ค่าคงที่ ธีม และเครื่องมือคำนวณ
│   ├── constants/              # App constants, Box names, Martial quotes
│   ├── theme/                  # Wuxia color palette, Typography, ThemeData
│   └── utils/                  # CultivationCalculator, DateFormatter
├── data/                       # ชั้นข้อมูล (Data Layer)
│   ├── datasources/            # HiveStorageService (Offline storage)
│   ├── models/                 # Mission, UserStats, CultivationRealm, CultivationLog
│   └── repositories/           # MissionRepository, StatsRepository
├── presentation/               # ชั้นการแสดงผล (Presentation Layer)
│   ├── providers/              # CultivationProvider, MissionProvider, SettingsProvider
│   ├── screens/                # Dashboard, Missions, Meditation, Chronicle, Settings
│   └── widgets/                # WuxiaCard, WuxiaButton, QiBar, WuxiaBadge, BreakthroughDialog
└── main.dart                   # Entry point & Provider injection
```

### การไหลของข้อมูล (Data Flow):
1. **User Action**: ผู้ใช้ทำภารกิจสำเร็จใน `MissionsScreen`
2. **Provider Update**: `MissionProvider` ส่งคำขอต่อไปยัง `CultivationProvider`
3. **Formula Calculation**: `CultivationCalculator` คำนวณ Qi ที่ได้รวมกับ Streak Bonus และอัปเดตสเตตัสใน `UserStats`
4. **Breakthrough Detection**: หาก `totalQi >= nextRealm.minQi` จะยิง Notification แจ้งเตือน และแสดง `BreakthroughDialog`
5. **Persistence**: บันทึก event รางวัลก่อน แล้วบันทึกยอด Qi/XP พร้อม applied-event ID ใน Hive value เดียว; log และ session อยู่คนละ box และกู้ต่อเมื่อเปิดแอปใหม่
6. **Reactive UI**: ทุกหน้าจอที่ Listen ข้อมูล (เช่น `BaguaRadarChart`, `RealmHeroCard`) จะ Re-render ข้อมูลใหม่อัตโนมัติ

---

## 📐 สูตรคำนวณและโมเดลการบ่มเพาะ (Cultivation Formulas)

### 1. สูตรคำนวณ Qi ของภารกิจ:
$$\text{Base Qi} = \begin{cases} 25 & (\text{ระดับ 1 - เบื้องต้น}) \\ 50 & (\text{ระดับ 2 - ทั่วไป}) \\ 100 & (\text{ระดับ 3 - ท้าทาย}) \\ 200 & (\text{ระดับ 4 - ทะลวงด่าน}) \end{cases}$$

$$\text{Qi Reward} = \text{Base Qi} + \left(\left\lfloor\frac{\text{Duration (mins)}}{15}\right\rfloor \times 5\right) + (\text{Daily Bonus: } 10)$$

$$\text{Effective Qi} = \text{Qi Reward} \times \left(1.0 + \min(\text{Streak Days} \times 0.02, 0.30)\right)$$

### 2. สูตรเลเวลของแต่ละสายวิชา (Stat Leveling Curve):
$$\text{Stat Level} = \left\lfloor\sqrt{\frac{\text{Stat XP}}{15}}\right\rfloor + 1$$

---

## 🧪 การทดสอบระบบ (Automated Unit Tests)

รันชุดทดสอบความถูกต้องของ Business Logic และ Data Models:

```bash
flutter test
```

ชุดการทดสอบครอบคลุม:
- ✅ `CultivationCalculator`: ทดสอบการคำนวณ XP, ตัวคูณ Streak, การกระจาย Stat, และการตรวจจับ Breakthrough
- ✅ `CultivationRealm`: ทดสอบการจับคู่ค่า Qi กับขอบเขตพลังยุทธภพทั้ง 20 ระดับ
- ✅ `Mission & UserStats Models`: ทดสอบ Serialization, Deserialization, และ CopyWith
- ✅ `Wuxia Widgets`: ทดสอบการ Render และ Callback ของปุ่มและ Badge

---

## 🚀 แนวทางการพัฒนาต่อยอด (Future Roadmap)

- [ ] **Cloud Sync (deferred)**: JSON export/import แบบ local พร้อมใช้แล้ว; ยังไม่มี Google Drive/Firebase sync
- [ ] **Custom Sects & Soundtracks**: เพิ่มเสียงดนตรีบรรเลงขลุ่ยจีนและพิณกู่เจิงประกอบการทำสมาธิ
- [ ] **Martial Arts Skill Tree (คัมภีร์ยุทธ์)**: ปลดล็อกกระบวนท่าและสกิลพิเศษเมื่อทำภารกิจในสายนั้น ๆ ครบตามเงื่อนไข

---

## 📄 ลิขสิทธิ์และการอ้างอิง (Licensing & Credits)

### คู่มือท่าฝึกแบบภาพ (Interactive Cultivation Manual)

- คู่มือทั้ง 18 ท่า รวม 55 ขั้น วาดเป็นเวกเตอร์ด้วย Flutter `CustomPainter` จากข้อมูลข้อต่อและทิศทางการเคลื่อนไหวใน `exercise_pose_catalog.dart` และ `exercise_figure_pose_catalog.dart` โดยใช้ตัววาดรูปร่าง เสื้อผ้า มือ และเท้าร่วมกันใน `exercise_human_figure_renderer.dart` ภาพ PNG เดิม 10 ภาพใน `assets/exercise_guides/` ยังอยู่เป็นภาพสำรอง โดยสร้างซ้ำได้ด้วย `tool/generate_exercise_guides.ps1` บน Windows ภาพและคำแนะนำทั้งหมดเปิดได้แบบออฟไลน์
- ข้อความและลำดับท่าอ้างอิง [Mayo Clinic: Cat/cow](https://www.mayoclinic.org/healthy-lifestyle/stress-management/multimedia/cat-cow-pose/vid-20453581), [NHS: Strength exercises](https://www.nhs.uk/live-well/exercise/strength-exercises/), [South Tees NHS: Wall press-ups](https://www.southtees.nhs.uk/resources/combined-press-ups/), [NHS Active Against Cancer: Chair dips](https://activeagainstcancer.nhs.uk/exercise-at-home/exercise-diary/), [Royal Berkshire NHS: Strength and conditioning](https://www.royalberkshire.nhs.uk/media/ljrncq23/strength-and-conditioning-exercise-class_jul25.pdf), [ACE: Incline push-up](https://www.acefitness.org/resources/pros/expert-articles/8972/be-a-chest-day-champion-an-evidence-based-approach-to-training-the-chest/) และ [ACE: Squat jumps](https://www.acefitness.org/resources/everyone/exercise-library/116/squat-jumps/) แหล่งอ้างอิงใช้ตรวจแนวคิดการเคลื่อนไหว ไม่ได้นำภาพต้นทางมาใช้
- ภาพทั้ง 18 ท่าและลำดับเริ่ม–เคลื่อนไหว–กลับถูกตรวจจาก golden gallery ใน `test/goldens/` ภาพ Cat-Cow ทั้ง 4 ขั้นมี golden แยกต่างหาก การเปลี่ยนภาพคู่มือไม่เปลี่ยนจำนวนครั้งหรือเซตฝึก
- ภาพแผนผังและคำบรรยายยังไม่ได้รับการตรวจท่าโดยผู้ฝึกสอนหรือกายภาพบำบัดที่มีคุณวุฒิ ก่อนเผยแพร่ให้ผู้ใช้ทั่วไปควรให้ผู้เชี่ยวชาญตรวจท่าทาง รวมถึงตรวจบนอุปกรณ์จริงและด้วยโปรแกรมอ่านหน้าจอ ผู้ใช้ควรหยุดเมื่อเจ็บหรือไม่สบาย

- **Typography**: Google Fonts ([Noto Sans Thai](https://fonts.google.com/specimen/Noto+Sans+Thai), [Cinzel](https://fonts.google.com/specimen/Cinzel), [Noto Serif Thai](https://fonts.google.com/specimen/Noto+Serif+Thai)) ภายใต้ Open Font License (OFL)
- **Icons**: Material Design Icons & Cupertino Icons
- **Project Structure & Code**: สงวนลิขสิทธิ์สำหรับผลงานส่วนตัวและการศึกษา (Personal Portfolio Project)
"# MURIM_PRACTICE" 
