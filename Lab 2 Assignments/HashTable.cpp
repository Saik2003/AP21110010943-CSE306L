#include <iostream>
#include <unordered_map>
using namespace std;

class SymbolTable
{
private:
    unordered_map<string, int> table;

public:
    void insert(const string &identifier, int value)
    {
        table[identifier] = value;
    }

    int lookup(const string &identifier)
    {
        if (table.find(identifier) != table.end())
            return table[identifier];
        return -1;
    }
};

int main()
{
    SymbolTable symbol_table;
    symbol_table.insert("variable1", 40);
    symbol_table.insert("function1", 10);

    cout << symbol_table.lookup("variable1") << endl;
    cout << symbol_table.lookup("function1") << endl;

    return 0;
}