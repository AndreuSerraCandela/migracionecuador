page 76128 "Carga Bitmap flags"
{
    ApplicationArea = all;

    Caption = 'Load Bitmap Flags';
    PageType = List;
    SourceTable = "FlagsInRepeater Bitmaps";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; rec.Status)
                {
                }
                field(Bitmap; rec.Bitmap)
                {
                }
            }
        }
    }

    actions
    {
    }
}

