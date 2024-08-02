// See https://aka.ms/new-console-template for more information

string[] fileContent = File.ReadAllLines(@"/boot/grub/grub.cfg");
string searchStr = "Archcraft Linux";
List<string> menuEntry = new List<string>();

for (int i = 0; i < fileContent.Length; i++)
{
    if (fileContent[i].Contains(searchStr))
    {
        for (int j = i; j < fileContent.Length; j++)
        {
            menuEntry.Add(fileContent[j]);
            if (fileContent[j].Contains("}"))
            {
                j = 9999;
                i = 9999;
            }
        }
    }

}

string[] splitLine = null;
foreach (var line in menuEntry)
{
    if (line.Contains("vmlinuz-linux"))
    {
        splitLine = line.Split(' ');
    }
}

if (splitLine == null)
    throw new NotSupportedException();
List<string> splitLineList = splitLine.ToList();
splitLineList.RemoveRange(0,2);
string bootArgs = String.Join(" ", splitLineList);
Console.WriteLine(bootArgs);