------杭州线路无法翻班临时解决
SELECT * FROM mcrouteinfogs r WHERE r.routename LIKE '%305%';
update asgn_dispatch_model m set m.isxiuban=(case substr(m.shifttype, 1, instr(m.shifttype, '/', 1, 1) - 1)
         when '' then '0' 
          when '1' then '0'
          when '2' then '1'
         else
          substr(m.shifttype, 1, instr(m.shifttype, '/', 1, 1) - 1)
       end),
       m.shifttype=(case
        substr(m.shifttype,
               instr(m.shifttype, '/', 1, 1) + 1,
               instr(m.shifttype, '/', 1, 2) - instr(m.shifttype, '/', 1, 1) - 1)
         when '单班' then
          '1'
         when '双班' then
          '2'
         else
          substr(m.shifttype,
                 instr(m.shifttype, '/', 1, 1) + 1,
                 instr(m.shifttype, '/', 1, 2) - instr(m.shifttype, '/', 1, 1) - 1)
       end) where m.shifttype like '%/%';
