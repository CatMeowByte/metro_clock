extends Node

const MONTH_NAME_GREGORIAN: Array = [
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
]
const MONTH_NAME_HIJRI: Array = [
	"Muharram",
	"Safar",
	"Rabi' al-Awwal",
	"Rabi' al-Thani",
	"Jumada al-Awwal",
	"Jumada al-Thani",
	"Rajab",
	"Sha'ban",
	"Ramadan",
	"Shawwal",
	"Dhu al-Qi'dah",
	"Dhu al-Hijjah",
]
const WEEKDAY_NAME_GREGORIAN: Array = [
	"Sunday",
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
]
const WEEKDAY_NAME_HIJRI: Array = [
	"Ahad",
	"Ithnayn",
	"Thulatha",
	"Arba'a",
	"Khamis",
	"Jumu'ah",
	"Sabt",
]


func _ready():
	# Initially trigger when hijri date is set, then update per hour
	GlobalDate.h_date_updated.connect(_on_h_date_updated)

func date_update():
	# Hijri day change at midday
	var hijri_offset = int(GlobalTime.t.hour >= 12)

	# Gregorian
	%YearG.text = str(GlobalDate.g.year)
	%MonthG.text = MONTH_NAME_GREGORIAN[GlobalDate.g.month - 1]
	%DayG.text = str(GlobalDate.g.day)
	%WeekdayG.text = WEEKDAY_NAME_GREGORIAN[GlobalDate.g.weekday]

	# Hijri
	%YearH.text = str(GlobalDate.h.year)
	%MonthH.text = MONTH_NAME_HIJRI[GlobalDate.h.month - 1]
	%DayH.text = str(wrap(GlobalDate.h.day + hijri_offset, 1, 30 + 1))

	# Hijri weekday is the same as Gregorian weekday
	%WeekdayH.text = WEEKDAY_NAME_HIJRI[wrap(GlobalDate.g.weekday + hijri_offset, 0, 7)]

func _on_h_date_updated():
	date_update()
	GlobalDate.h_date_updated.disconnect(_on_h_date_updated)
	GlobalTime.hour_updated.connect(date_update)
