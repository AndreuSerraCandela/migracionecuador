codeunit 75003 "Web Service MdM"
{

    trigger OnRun()
    begin
    end;

    procedure insert(mensaje: XMLport "Articulos_Formato_MDM - INSERT"; var result: XMLport "Resp. Web Service MdM")
    var
        Msg: Text[250];
        lwOutStrm: OutStream;
        lwIDC: Integer;
    begin
        // Insert

        mensaje.Import;
        mensaje.GetOutStrm(lwOutStrm);
        mensaje.SetDestination(lwOutStrm);
        mensaje.Export;
        mensaje.GestMessageXML(result);
    end;

    procedure update(mensaje: XMLport "Articulos_Formato_MDM - UPDATE"; var result: XMLport "Resp. Web Service MdM")
    var
        Msg: Text[250];
        lwOutStrm: OutStream;
        lwIDR: Integer;
    begin
        // Update

        mensaje.Import;
        mensaje.GetOutStrm(lwOutStrm);
        mensaje.SetDestination(lwOutStrm);
        mensaje.Export;
        mensaje.GestMessageXML(result);
    end;

    procedure delete(mensaje: XMLport "Articulos_Formato_MDM - DELETE"; var result: XMLport "Resp. Web Service MdM")
    var
        Msg: Text[250];
        lwOutStrm: OutStream;
        lwIDR: Integer;
    begin
        // Delete

        mensaje.Import;
        mensaje.GetOutStrm(lwOutStrm);
        mensaje.SetDestination(lwOutStrm);
        mensaje.Export;
        mensaje.GestMessageXML(result);
    end;
}

