Given /^today is( always)? "(.+)"( at ".+")?$/ do |freeze, date, time|
  travel_or_freeze = (freeze.present?) ? :freeze : :travel
  Timecop.return

  if time
    time = time.split('"').last
    Timecop.send(travel_or_freeze, DateTime.parse("#{date} #{time}"))
  else
    Timecop.send(travel_or_freeze, Date.parse(date))
  end
end

Given /^the time is "(.+)"$/ do |time|
  Timecop.return
  Timecop.travel(DateTime.parse(time))
end

Then /^the current time zone should be "(.+)"$/ do |time_zone|
  Time.zone.name.should == time_zone
end

Then /^I should see the date( and time)? today$/ do |with_time|
  if with_time
    step %{I should see "#{DateTime.now}"}
  else
    step %{I should see "#{Date.today}"}
  end
end
