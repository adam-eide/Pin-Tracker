year = "2008"
series = 1
wave = 1
pins = [10]
#name = ["Teddy Bear", "Princess Eyes", "Muppets", "Villain Crystal Ball", "Donald Riding", "Pirates", "Fruit", "Tikis", "Little Dudes", "Fluff Cats", "Figment", "Haunted Mansion", "Monorail", "Footprints", "Bumper Cars", "Pin Trading", "Fast Pass", "Chip and Dale Travels"]
name = ["CMP Teddy Bear", "CMP Fruit","CMP Figment","CMP Donald Riding","CMP Fast Pass","CMP Fluff Cats","CMP Pin Trading","CMP Princess Eyes","CMP Haunted Mansion","CMP Bumper Cars"]
def main():
    for x in range(0, series):
        sql(19)



def makeList():
    for x in range(1, series+1):
        out = "pinList.add(PinSet(\"{}_{}_full.png\", {}, {}, {}));".format(year, x, year, wave, x)
        print(out)



def sql(set_number):
    for x in range(1,11):
        out = """INSERT INTO PINS (Year, Wave, Series, Number, Qty, Description, Path)
VALUES({}, {}, {}, {}, 0, \"{}\", \"{}_{}_{}.png\");""".format(year, wave, set_number, x, name[x-1], year, set_number, x)
        print(out)

main()