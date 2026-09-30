# 🥋 Murim Study Tracker (บันทึกการฝึกตนและบ่มเพาะวรยุทธ์)

> **Gamified Habit & Study Tracker Application** ในธีมกำลังภายใน (Oriental Wuxia / Cultivation) พัฒนาด้วย Flutter & Dart พร้อมสถาปัตยกรรม **Offline-First Reactive UI** และกราฟยันต์แปดทิศ (Bagua Radar Chart)

---

## 📖 สารบัญ (Table of Contents)
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

**Murim Study Tracker** เป็นแอปพลิเคชันจัดการการเรียนรู้และพัฒนาตนเอง (Habit & Task Tracker) ที่นำแนวคิด **Gamification** มาผนวกกับเสน่ห์ของโลกกำลังภายใน เปลี่ยนกิจกรรมในชีวิตประจำวัน เช่น การอ่านหนังสือ การเขียนโค้ด การออกกำลังกาย และการทำสมาธิ ให้กลายเป็นการสะสมพลังปราณ (Qi), ทะลวงจุดชีพจร, และเลื่อนขั้นขอบเขตยุทธภพสู่ระดับ "เซียนสวรรค์ไร้พ่าย"

### จุดเด่นสำคัญ:
1. **ธีมกำลังภายในระดับพรีเมียม (Oriental Wuxia Dark Mode)**: โทนสีหยกมังกร (Jade), ทองคำศักดิ์สิทธิ์ (Imperial Gold), และปราณฟ้า (Qi Cyan) บนพื้นหลังกระดาษคัมภีร์โบราณและหมึกจีน
2. **ยันต์แปดทิศสเตตัสวรยุทธ์ (Reactive Bagua Radar Chart)**: กราฟเรดาร์ 6 มิติที่อัปเดตสเตตัสแบบ Reactive ทันทีที่มีการทำภารกิจสำเร็จ
3. **ระบบทะลวงด่าน 20 ระดับ (Cultivation Realms & Breakthrough Dialog)**: สัมผัสความตื่นเต้นเมื่อพลัง Qi สะสมถึงจุดสูงสุดและปลดล็อกขอบเขตใหม่
4. **ห้องปิดด่านฝึกตน (Secluded Focus Timer)**: ระบบจับเวลาสมาธิและโฟกัสพร้อมแอนิเมชันลูกแก้วลมปราณหมุนเวียน
5. **ทำงานแบบออฟไลน์ 100% (Offline-First with Hive)**: ข้อมูลทั้งหมดถูกจัดเก็บอย่างปลอดภัยบนเครื่องของผู้ใช้ รองรับทั้ง Windows Desktop และ Mobile

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
5. **Persistence**: บันทึกข้อมูลลงใน Hive Local Storage ทันทีแบบ Atomic
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

- [ ] **Cloud Sync & Backup**: เพิ่มระบบสำรองข้อมูลผ่าน Google Drive / Firebase สำหรับผู้ใช้ที่ต้องการย้ายเครื่อง
- [ ] **Custom Sects & Soundtracks**: เพิ่มเสียงดนตรีบรรเลงขลุ่ยจีนและพิณกู่เจิงประกอบการทำสมาธิ
- [ ] **Martial Arts Skill Tree (คัมภีร์ยุทธ์)**: ปลดล็อกกระบวนท่าและสกิลพิเศษเมื่อทำภารกิจในสายนั้น ๆ ครบตามเงื่อนไข

---

## 📄 ลิขสิทธิ์และการอ้างอิง (Licensing & Credits)

- **Typography**: Google Fonts ([Noto Sans Thai](https://fonts.google.com/specimen/Noto+Sans+Thai), [Cinzel](https://fonts.google.com/specimen/Cinzel), [Noto Serif Thai](https://fonts.google.com/specimen/Noto+Serif+Thai)) ภายใต้ Open Font License (OFL)
- **Icons**: Material Design Icons & Cupertino Icons
- **Project Structure & Code**: สงวนลิขสิทธิ์สำหรับผลงานส่วนตัวและการศึกษา (Personal Portfolio Project)
