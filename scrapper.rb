require 'date'
require 'ferrum'


def get_planning(user, file_name="schedule")
  browser = Ferrum::Browser.new()
  browser.go_to("https://extra.u-picardie.fr/calendar/Login")

  browser.at_css("input#username").focus.type(user[:login])
  browser.at_css("input#password").focus.type(user[:password])
  browser.at_css("button[type='submit']").focus.click
  browser.network.wait_for_idle
  sleep(2)
  browser.at_css(".fc-agendaWeek-button").focus.click
  browser.at_css(".fc-next-button.fc-button.fc-state-default.fc-corner-right").focus.click if Time.now.sunday?
  # w h y does the page still load AFTER the network's gone idle?????????
  browser.network.wait_for_idle
  sleep(2)
  # Bro, this is awful. Genuinely couldn't find a better way to get a clean screenshot. Awful shit.
  browser.execute("
    document.querySelector('#calBrowseBarDiv').style.display = 'none';
    document.querySelector('.navbar.navbar-inverse.navbar-fixed-top').style.display = 'none';
    document.querySelector('#ctColourKey').style.display = 'none';
    document.querySelector('footer').style.display = 'none';  
  ")

  browser.screenshot(path: "#{file_name}.png",selector: "#calendar")
  # browser.screenshot(path: "schedule2.png", full: true)
  # You´d think a full-page screenshot would be better. . . .
  browser.quit
end