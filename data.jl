using HTTP
using Gumbo
using Cascadia
using DataFrames
using CSV

function create_url(base, set)
    return replace(base, "SET" => set)
end


sets = ["W4-11", "G21EA", "G21IP", "DIPCS10", "PA26", "SIE4x4", "ALKBDE10", "YBDE18", "AL2X6", "HEAVYSB11", "NBPRC", "ALK8", "RC21", "G2RC", "BH76RC", "FH51", "TAUT15", "DC13", 
	"MB16-43", "DARC", "RSE43", "BSR36", "CDIE20", "ISO34", "ISOL24", "C60ISO", "PArel", 
	"BH76", "BHPERI", "BHDIV10", "INV24", "BHROT27", "PX13", "WCPT18", 
	"RG18", "ADIM6", "S22", "S66", "HEAVY28", "WATER27", "CARBHB12", "PNICO23", "HAL59", "AHB21", "CHB6", "IL16", 
	"IDISP", "ICONF", "ACONF", "Amino20x4", "PCONF21", "MCONF", "SCONF", "UPU23", "BUT14DIOL"]

sets = ["HAL59"] 
for set in sets
    geom_url = create_url("http://www.thch.uni-bonn.de/tc.old/downloads/GMTKN/GMTKN55/SET.tar", set)
    ref_url = create_url("http://www.thch.uni-bonn.de/tc.old/downloads/GMTKN/GMTKN55/SETref.html", set)
    cm_url = create_url("http://www.thch.uni-bonn.de/tc.old/downloads/GMTKN/GMTKN55/CHARGE_MULTIPLICITY_SET.txt", set)

    try
	# Download tar
        HTTP.download(geom_url, set * ".tar")
        HTTP.download(cm_url, set * ".txt")
	
	# Download ref data
	html = String(HTTP.get(ref_url).body)
        parsed = parsehtml(html)
        selector = Selector("table")
        tables = eachmatch(selector, parsed.root)
	table = first(tables)

        rows = eachmatch(Selector("tr"), table)
        data = [
            [strip(nodeText(cell)) for cell in eachmatch(Selector("td,th"), row)]
            for row in rows
        ]
	data_rows = data[2:end]
        df = DataFrame(data_rows, :auto)
	CSV.write(set * ".csv", permutedims(df))
    catch
        println("Error downloading file: $set")
    end

end
