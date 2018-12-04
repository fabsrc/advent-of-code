import re, sys

def most_sleeping(input):
  entries = sorted([e[1:].split("] ") for e in input.splitlines()], key=lambda x: x[0])
  timetable = dict()

  for date, text in entries:
    guard_id_match = re.search(r"#(\d+)", text)
    if guard_id_match:
      current_guard = guard_id_match.group(1)
      if current_guard not in timetable:
        timetable[current_guard] = [0] * 60
    elif "asleep" in text:
      start_minute = int(re.search(r"\d{2}$", date).group(0))
    elif "wakes up" in text:
      end_minute = int(re.search(r"\d{2}$", date).group(0))
      for minute in range(start_minute, end_minute):
        timetable[current_guard][minute] += 1
  
  sleepiest_guard = max(timetable, key=(lambda x: sum(timetable[x])))
  sleepiest_minute = timetable[sleepiest_guard].index(max(timetable[sleepiest_guard]))

  return int(sleepiest_guard) * sleepiest_minute

assert most_sleeping("""[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
""") == 240

if len(sys.argv) > 1:
  print(most_sleeping(sys.argv[1]))
