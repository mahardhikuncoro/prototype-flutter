/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

class DELETE {
    static const String PATH_PARAMETER = "*PATH_PARAMETER*";
    final String value;
    final dynamic as;
    final dynamic error;

    const DELETE({this.value = "", this.as = String, this.error = String});
}