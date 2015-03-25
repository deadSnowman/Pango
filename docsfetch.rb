require "rubygems"
require "google_drive"
require "json"

session = GoogleDrive.login("romanronin92@gmail.com", "Bugzilla92!!")
ws = session.spreadsheet_by_key("15OytQnNhqAGWjE8Sn_JT1uPbUMaWFYsBI_lnd_F7vFc").worksheets[0]
acData = Hash.new

for row in 2..ws.num_rows
  acData[ws[row, 2].downcase] = { :villagername => ws[row, 3], 
                         :dsname => ws[row, 4], 
                         :townname => ws[row, 5], 
                         :fruit => ws[row, 6],
                         :fc => ws[row, 7],
                         :da => ws[row, 8],
                         :timezone => ws[row, 9],
                         :timezone2 => ws[row, 10],
                         :notes => ws[row, 11],
                         :ssheet => ws[row, 12]}
end

acData.store(:pango, { :fc => "snooooof"})

File.open("acdata.json", "w"){ |file| file.write(JSON.pretty_generate(acData))}

ws.reload()

