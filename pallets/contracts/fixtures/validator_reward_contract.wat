(module
  (type (;0;) (func (param i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (type (;2;) (func (param i32 i32)))
  (type (;3;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;4;) (func (param i32 i32 i32)))
  (type (;5;) (func (param i32 i32 i32 i32)))
  (type (;6;) (func (param i32)))
  (type (;7;) (func (param i32 i32 i32 i32 i32)))
  (type (;8;) (func))
  (type (;9;) (func (param i32 i64)))
  (type (;10;) (func (param i64 i64 i32)))
  (type (;11;) (func (result i32)))
  (type (;12;) (func (param i32) (result i32)))
  (import "seal1" "get_storage" (func (;0;) (type 3)))
  (import "seal0" "value_transferred" (func (;1;) (type 2)))
  (import "seal0" "input" (func (;2;) (type 2)))
  (import "seal0" "caller" (func (;3;) (type 2)))
  (import "seal0" "debug_message" (func (;4;) (type 1)))
  (import "seal0" "transfer" (func (;5;) (type 3)))
  (import "seal2" "set_storage" (func (;6;) (type 3)))
  (import "seal0" "seal_return" (func (;7;) (type 4)))
  (import "env" "memory" (memory (;0;) 2 16))
  (func (;8;) (type 0) (param i32 i32 i32) (result i32)
    (local i32)
    loop (result i32)  ;; label = @1
      local.get 2
      local.get 3
      i32.eq
      if (result i32)  ;; label = @2
        local.get 0
      else
        local.get 0
        local.get 3
        i32.add
        local.get 1
        local.get 3
        i32.add
        i32.load8_u
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        br 1 (;@1;)
      end
    end)
  (func (;9;) (type 0) (param i32 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      local.get 1
      i32.le_u
      if  ;; label = @2
        local.get 0
        local.set 3
        loop  ;; label = @3
          local.get 2
          i32.eqz
          br_if 2 (;@1;)
          local.get 3
          local.get 1
          i32.load8_u
          i32.store8
          local.get 3
          i32.const 1
          i32.add
          local.set 3
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 2
          i32.const 1
          i32.sub
          local.set 2
          br 0 (;@3;)
        end
        unreachable
      end
      local.get 0
      i32.const 1
      i32.sub
      local.set 3
      local.get 1
      i32.const 1
      i32.sub
      local.set 1
      loop  ;; label = @2
        local.get 2
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        local.get 3
        i32.add
        local.get 1
        local.get 2
        i32.add
        i32.load8_u
        i32.store8
        local.get 2
        i32.const 1
        i32.sub
        local.set 2
        br 0 (;@2;)
      end
      unreachable
    end
    local.get 0)
  (func (;10;) (type 0) (param i32 i32 i32) (result i32)
    (local i32)
    loop (result i32)  ;; label = @1
      local.get 2
      local.get 3
      i32.eq
      if (result i32)  ;; label = @2
        local.get 0
      else
        local.get 0
        local.get 3
        i32.add
        local.get 1
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        br 1 (;@1;)
      end
    end)
  (func (;11;) (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32)
    loop  ;; label = @1
      local.get 2
      i32.eqz
      if  ;; label = @2
        i32.const 0
        return
      end
      local.get 2
      i32.const 1
      i32.sub
      local.set 2
      local.get 1
      i32.load8_u
      local.set 3
      local.get 0
      i32.load8_u
      local.set 4
      local.get 1
      i32.const 1
      i32.add
      local.set 1
      local.get 0
      i32.const 1
      i32.add
      local.set 0
      local.get 3
      local.get 4
      i32.eq
      br_if 0 (;@1;)
    end
    local.get 4
    local.get 3
    i32.sub)
  (func (;12;) (type 9) (param i32 i64)
    (local i32 i64 i64 i64 i64)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    local.get 1
    i64.const 4294967295
    i64.and
    local.tee 3
    i64.const 3567587328
    i64.mul
    local.tee 4
    local.get 3
    i64.const 232
    i64.mul
    local.tee 3
    local.get 1
    i64.const 32
    i64.shr_u
    local.tee 5
    i64.const 3567587328
    i64.mul
    i64.add
    local.tee 1
    i64.const 32
    i64.shl
    i64.add
    local.tee 6
    i64.store
    local.get 2
    local.get 4
    local.get 6
    i64.gt_u
    i64.extend_i32_u
    local.get 5
    i64.const 232
    i64.mul
    local.get 1
    local.get 3
    i64.lt_u
    i64.extend_i32_u
    i64.const 32
    i64.shl
    local.get 1
    i64.const 32
    i64.shr_u
    i64.or
    i64.add
    i64.add
    i64.store offset=8
    local.get 2
    i64.load
    local.set 1
    local.get 0
    local.get 2
    i32.const 8
    i32.add
    i64.load
    i64.store offset=8
    local.get 0
    local.get 1
    i64.store
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;13;) (type 5) (param i32 i32 i32 i32)
    local.get 1
    local.get 3
    i32.gt_u
    if  ;; label = @1
      local.get 1
      local.get 3
      i32.const 65848
      call 14
      unreachable
    end
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store)
  (func (;14;) (type 4) (param i32 i32 i32)
    (local i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    local.get 1
    i32.store offset=4
    local.get 3
    local.get 0
    i32.store
    local.get 3
    i32.const 44
    i32.add
    i32.const 4
    i32.store
    local.get 3
    i32.const 2
    i32.store offset=12
    local.get 3
    i32.const 67400
    i32.store offset=8
    local.get 3
    i64.const 2
    i64.store offset=20 align=4
    local.get 3
    i32.const 4
    i32.store offset=36
    local.get 3
    local.get 3
    i32.const 32
    i32.add
    i32.store offset=16
    local.get 3
    local.get 3
    i32.const 4
    i32.add
    i32.store offset=40
    local.get 3
    local.get 3
    i32.store offset=32
    local.get 3
    i32.const 8
    i32.add
    local.get 2
    call 25
    unreachable)
  (func (;15;) (type 2) (param i32 i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    i32.const 24
    i32.add
    local.tee 3
    i64.const 0
    i64.store
    local.get 2
    i32.const 16
    i32.add
    local.tee 4
    i64.const 0
    i64.store
    local.get 2
    i32.const 8
    i32.add
    local.tee 5
    i64.const 0
    i64.store
    local.get 2
    i64.const 0
    i64.store
    local.get 0
    block (result i32)  ;; label = @1
      local.get 1
      local.get 2
      i32.const 32
      call 16
      i32.eqz
      if  ;; label = @2
        local.get 0
        local.get 2
        i64.load
        i64.store offset=1 align=1
        local.get 0
        i32.const 25
        i32.add
        local.get 3
        i64.load
        i64.store align=1
        local.get 0
        i32.const 17
        i32.add
        local.get 4
        i64.load
        i64.store align=1
        local.get 0
        i32.const 9
        i32.add
        local.get 5
        i64.load
        i64.store align=1
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 1
    end
    i32.store8
    local.get 2
    i32.const 32
    i32.add
    global.set 0)
  (func (;16;) (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32)
    local.get 0
    i32.load offset=4
    local.tee 3
    local.get 2
    i32.lt_u
    local.tee 4
    i32.eqz
    if  ;; label = @1
      local.get 1
      local.get 2
      local.get 0
      i32.load
      local.tee 1
      local.get 2
      i32.const 68156
      call 56
      local.get 0
      local.get 3
      local.get 2
      i32.sub
      i32.store offset=4
      local.get 0
      local.get 1
      local.get 2
      i32.add
      i32.store
    end
    local.get 4)
  (func (;17;) (type 2) (param i32 i32)
    local.get 1
    local.get 0
    i32.const 32
    call 18)
  (func (;18;) (type 4) (param i32 i32 i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=8
      local.tee 4
      local.get 2
      i32.add
      local.tee 3
      local.get 4
      i32.ge_u
      if  ;; label = @2
        local.get 3
        local.get 0
        i32.load offset=4
        local.tee 5
        i32.gt_u
        br_if 1 (;@1;)
        local.get 0
        i32.load
        local.get 4
        i32.add
        local.get 2
        local.get 1
        local.get 2
        i32.const 67996
        call 56
        local.get 0
        local.get 3
        i32.store offset=8
        return
      end
      global.get 0
      i32.const 48
      i32.sub
      local.tee 0
      global.set 0
      local.get 0
      local.get 3
      i32.store offset=4
      local.get 0
      local.get 4
      i32.store
      local.get 0
      i32.const 44
      i32.add
      i32.const 4
      i32.store
      local.get 0
      i32.const 2
      i32.store offset=12
      local.get 0
      i32.const 67452
      i32.store offset=8
      local.get 0
      i64.const 2
      i64.store offset=20 align=4
      local.get 0
      i32.const 4
      i32.store offset=36
      local.get 0
      local.get 0
      i32.const 32
      i32.add
      i32.store offset=16
      local.get 0
      local.get 0
      i32.const 4
      i32.add
      i32.store offset=40
      local.get 0
      local.get 0
      i32.store offset=32
      local.get 0
      i32.const 8
      i32.add
      i32.const 67980
      call 25
      unreachable
    end
    local.get 3
    local.get 5
    i32.const 67980
    call 14
    unreachable)
  (func (;19;) (type 10) (param i64 i64 i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    local.get 1
    i64.store offset=8
    local.get 3
    local.get 0
    i64.store
    local.get 2
    local.get 3
    i32.const 16
    call 18
    local.get 3
    i32.const 16
    i32.add
    global.set 0)
  (func (;20;) (type 6) (param i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 1
    global.set 0
    local.get 1
    i32.const 0
    i32.store offset=12
    local.get 0
    local.get 1
    i32.const 12
    i32.add
    i32.const 4
    call 18
    local.get 1
    i32.const 16
    i32.add
    global.set 0)
  (func (;21;) (type 11) (result i32)
    (local i32 i32 i64 i64)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 0
    global.set 0
    local.get 0
    i32.const 16
    i32.add
    local.tee 1
    i64.const 0
    i64.store
    local.get 0
    i64.const 0
    i64.store offset=8
    local.get 0
    i32.const 16
    i32.store offset=28
    local.get 0
    i32.const 8
    i32.add
    local.get 0
    i32.const 28
    i32.add
    call 1
    local.get 1
    i64.load
    local.set 2
    local.get 0
    i64.load offset=8
    local.set 3
    local.get 0
    i32.const 32
    i32.add
    global.set 0
    i32.const 5
    i32.const 4
    local.get 2
    local.get 3
    i64.or
    i64.eqz
    select)
  (func (;22;) (type 4) (param i32 i32 i32)
    (local i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 3
    global.set 0
    local.get 2
    local.get 1
    i32.load offset=4
    local.tee 4
    i32.gt_u
    if  ;; label = @1
      local.get 3
      i32.const 0
      i32.store offset=24
      local.get 3
      i32.const 1
      i32.store offset=12
      local.get 3
      i32.const 67836
      i32.store offset=8
      local.get 3
      i64.const 4
      i64.store offset=16 align=4
      local.get 3
      i32.const 8
      i32.add
      i32.const 68028
      call 25
      unreachable
    end
    local.get 1
    local.get 4
    local.get 2
    i32.sub
    i32.store offset=4
    local.get 1
    local.get 1
    i32.load
    local.tee 1
    local.get 2
    i32.add
    i32.store
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store
    local.get 3
    i32.const 32
    i32.add
    global.set 0)
  (func (;23;) (type 7) (param i32 i32 i32 i32 i32)
    (local i32)
    global.get 0
    i32.const -64
    i32.add
    local.tee 5
    global.set 0
    local.get 5
    local.get 1
    i32.store offset=12
    local.get 5
    local.get 0
    i32.store offset=8
    local.get 5
    local.get 3
    i32.store offset=20
    local.get 5
    local.get 2
    i32.store offset=16
    local.get 5
    i32.const 60
    i32.add
    i32.const 1
    i32.store
    local.get 5
    i32.const 2
    i32.store offset=28
    local.get 5
    i32.const 67124
    i32.store offset=24
    local.get 5
    i64.const 2
    i64.store offset=36 align=4
    local.get 5
    i32.const 2
    i32.store offset=52
    local.get 5
    local.get 5
    i32.const 48
    i32.add
    i32.store offset=32
    local.get 5
    local.get 5
    i32.const 16
    i32.add
    i32.store offset=56
    local.get 5
    local.get 5
    i32.const 8
    i32.add
    i32.store offset=48
    local.get 5
    i32.const 24
    i32.add
    local.get 4
    call 25
    unreachable)
  (func (;24;) (type 1) (param i32 i32) (result i32)
    (local i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    i32.const 1
    i32.store offset=12
    local.get 2
    i32.const 67696
    i32.store offset=8
    local.get 2
    i64.const 1
    i64.store offset=20 align=4
    local.get 2
    i32.const 2
    i32.store offset=36
    local.get 2
    local.get 0
    i32.load8_u
    i32.const 2
    i32.shl
    local.tee 0
    i32.const 68172
    i32.add
    i32.load
    i32.store offset=44
    local.get 2
    local.get 0
    i32.const 68192
    i32.add
    i32.load
    i32.store offset=40
    local.get 2
    local.get 2
    i32.const 32
    i32.add
    i32.store offset=16
    local.get 2
    local.get 2
    i32.const 40
    i32.add
    i32.store offset=32
    local.get 1
    i32.load offset=20
    local.get 1
    i32.load offset=24
    local.get 2
    i32.const 8
    i32.add
    call 44
    local.set 0
    local.get 2
    i32.const 48
    i32.add
    global.set 0
    local.get 0)
  (func (;25;) (type 2) (param i32 i32)
    (local i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    i32.const 16
    i32.add
    local.get 0
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get 2
    i32.const 8
    i32.add
    local.get 0
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get 2
    i32.const 1
    i32.store16 offset=28
    local.get 2
    local.get 1
    i32.store offset=24
    local.get 2
    local.get 0
    i64.load align=4
    i64.store
    local.get 2
    call 50
    unreachable)
  (func (;26;) (type 2) (param i32 i32)
    (local i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    i32.const 0
    i32.store offset=12
    block  ;; label = @1
      local.get 1
      local.get 2
      i32.const 12
      i32.add
      i32.const 4
      call 16
      i32.eqz
      if  ;; label = @2
        local.get 2
        i32.load offset=12
        local.set 1
        br 1 (;@1;)
      end
      i32.const 1
      local.set 3
    end
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 3
    i32.store
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;27;) (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 0
                                i32.load8_u
                                i32.const 1
                                i32.sub
                                br_table 1 (;@13;) 2 (;@12;) 3 (;@11;) 4 (;@10;) 5 (;@9;) 6 (;@8;) 7 (;@7;) 8 (;@6;) 9 (;@5;) 10 (;@4;) 11 (;@3;) 12 (;@2;) 0 (;@14;)
                              end
                              i32.const 1
                              local.set 0
                              local.get 1
                              i32.load offset=20
                              local.tee 3
                              i32.const 65552
                              i32.const 6
                              local.get 1
                              i32.load offset=24
                              local.tee 5
                              i32.load offset=12
                              local.tee 4
                              call_indirect (type 0)
                              br_if 12 (;@1;)
                              block  ;; label = @14
                                local.get 1
                                i32.load8_u offset=28
                                i32.const 4
                                i32.and
                                i32.eqz
                                if  ;; label = @15
                                  local.get 3
                                  i32.const 67146
                                  i32.const 1
                                  local.get 4
                                  call_indirect (type 0)
                                  br_if 14 (;@1;)
                                  local.get 3
                                  i32.const 66412
                                  i32.const 5
                                  local.get 4
                                  call_indirect (type 0)
                                  i32.eqz
                                  br_if 1 (;@14;)
                                  br 14 (;@1;)
                                end
                                local.get 3
                                i32.const 67147
                                i32.const 2
                                local.get 4
                                call_indirect (type 0)
                                br_if 13 (;@1;)
                                local.get 2
                                local.get 5
                                i32.store offset=4
                                local.get 2
                                local.get 3
                                i32.store
                                local.get 2
                                i32.const 1
                                i32.store8 offset=15
                                local.get 2
                                local.get 2
                                i32.const 15
                                i32.add
                                i32.store offset=8
                                local.get 2
                                i32.const 66412
                                i32.const 5
                                call 28
                                br_if 13 (;@1;)
                                local.get 2
                                i32.const 67144
                                i32.const 2
                                call 28
                                br_if 13 (;@1;)
                              end
                              local.get 3
                              i32.const 67012
                              i32.const 1
                              local.get 4
                              call_indirect (type 0)
                              local.set 0
                              br 12 (;@1;)
                            end
                            local.get 1
                            i32.load offset=20
                            i32.const 65558
                            i32.const 13
                            local.get 1
                            i32.load offset=24
                            i32.load offset=12
                            call_indirect (type 0)
                            local.set 0
                            br 11 (;@1;)
                          end
                          local.get 1
                          i32.load offset=20
                          i32.const 65571
                          i32.const 14
                          local.get 1
                          i32.load offset=24
                          i32.load offset=12
                          call_indirect (type 0)
                          local.set 0
                          br 10 (;@1;)
                        end
                        local.get 1
                        i32.load offset=20
                        i32.const 65585
                        i32.const 11
                        local.get 1
                        i32.load offset=24
                        i32.load offset=12
                        call_indirect (type 0)
                        local.set 0
                        br 9 (;@1;)
                      end
                      local.get 1
                      i32.load offset=20
                      i32.const 65596
                      i32.const 26
                      local.get 1
                      i32.load offset=24
                      i32.load offset=12
                      call_indirect (type 0)
                      local.set 0
                      br 8 (;@1;)
                    end
                    local.get 1
                    i32.load offset=20
                    i32.const 65622
                    i32.const 14
                    local.get 1
                    i32.load offset=24
                    i32.load offset=12
                    call_indirect (type 0)
                    local.set 0
                    br 7 (;@1;)
                  end
                  local.get 1
                  i32.load offset=20
                  i32.const 65636
                  i32.const 16
                  local.get 1
                  i32.load offset=24
                  i32.load offset=12
                  call_indirect (type 0)
                  local.set 0
                  br 6 (;@1;)
                end
                local.get 1
                i32.load offset=20
                i32.const 65652
                i32.const 12
                local.get 1
                i32.load offset=24
                i32.load offset=12
                call_indirect (type 0)
                local.set 0
                br 5 (;@1;)
              end
              local.get 1
              i32.load offset=20
              i32.const 65664
              i32.const 11
              local.get 1
              i32.load offset=24
              i32.load offset=12
              call_indirect (type 0)
              local.set 0
              br 4 (;@1;)
            end
            local.get 1
            i32.load offset=20
            i32.const 65675
            i32.const 7
            local.get 1
            i32.load offset=24
            i32.load offset=12
            call_indirect (type 0)
            local.set 0
            br 3 (;@1;)
          end
          local.get 1
          i32.load offset=20
          i32.const 65682
          i32.const 15
          local.get 1
          i32.load offset=24
          i32.load offset=12
          call_indirect (type 0)
          local.set 0
          br 2 (;@1;)
        end
        local.get 1
        i32.load offset=20
        i32.const 65697
        i32.const 17
        local.get 1
        i32.load offset=24
        i32.load offset=12
        call_indirect (type 0)
        local.set 0
        br 1 (;@1;)
      end
      local.get 1
      i32.load offset=20
      i32.const 65714
      i32.const 19
      local.get 1
      i32.load offset=24
      i32.load offset=12
      call_indirect (type 0)
      local.set 0
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func (;28;) (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const -64
    i32.add
    local.tee 3
    global.set 0
    local.get 3
    i32.const 0
    i32.store16 offset=60
    local.get 3
    local.get 2
    i32.store offset=56
    local.get 3
    i32.const 0
    i32.store offset=52
    local.get 3
    i32.const 1
    i32.store8 offset=48
    local.get 3
    i32.const 10
    i32.store offset=44
    local.get 3
    local.get 2
    i32.store offset=40
    local.get 3
    i32.const 0
    i32.store offset=36
    local.get 3
    local.get 2
    i32.store offset=32
    local.get 3
    local.get 1
    i32.store offset=28
    local.get 3
    i32.const 10
    i32.store offset=24
    local.get 0
    i32.load offset=4
    local.set 10
    local.get 0
    i32.load
    local.set 11
    local.get 0
    i32.load offset=8
    local.set 12
    local.get 3
    i32.const 44
    i32.add
    local.set 13
    block (result i32)  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.load offset=28
            local.set 7
            block (result i32)  ;; label = @5
              block  ;; label = @6
                local.get 3
                i32.load offset=40
                local.tee 5
                local.get 3
                i32.load offset=32
                local.tee 16
                i32.gt_u
                br_if 0 (;@6;)
                local.get 5
                local.get 3
                i32.load offset=36
                local.tee 4
                i32.lt_u
                br_if 0 (;@6;)
                local.get 3
                i32.load8_u offset=48
                local.tee 0
                local.get 13
                i32.add
                i32.const 1
                i32.sub
                i32.load8_u
                local.tee 8
                i32.const 16843009
                i32.mul
                local.set 14
                local.get 0
                i32.const 5
                i32.lt_u
                local.set 17
                loop  ;; label = @7
                  local.get 4
                  local.get 7
                  i32.add
                  local.set 1
                  block  ;; label = @8
                    block  ;; label = @9
                      block (result i32)  ;; label = @10
                        block  ;; label = @11
                          local.get 5
                          local.get 4
                          i32.sub
                          local.tee 6
                          i32.const 8
                          i32.ge_u
                          if  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 1
                                local.get 1
                                i32.const 3
                                i32.add
                                i32.const -4
                                i32.and
                                local.tee 2
                                i32.eq
                                if  ;; label = @15
                                  local.get 6
                                  i32.const 8
                                  i32.sub
                                  local.set 15
                                  i32.const 0
                                  local.set 2
                                  br 1 (;@14;)
                                end
                                local.get 3
                                i32.const 16
                                i32.add
                                local.get 8
                                local.get 1
                                local.get 2
                                local.get 1
                                i32.sub
                                local.tee 2
                                call 62
                                local.get 3
                                i32.load offset=16
                                i32.const 1
                                i32.eq
                                br_if 1 (;@13;)
                                local.get 2
                                local.get 6
                                i32.const 8
                                i32.sub
                                local.tee 15
                                i32.gt_u
                                br_if 3 (;@11;)
                              end
                              loop  ;; label = @14
                                local.get 1
                                local.get 2
                                i32.add
                                local.tee 9
                                i32.const 4
                                i32.add
                                i32.load
                                local.get 14
                                i32.xor
                                local.tee 18
                                i32.const -1
                                i32.xor
                                local.get 18
                                i32.const 16843009
                                i32.sub
                                i32.and
                                local.get 9
                                i32.load
                                local.get 14
                                i32.xor
                                local.tee 9
                                i32.const -1
                                i32.xor
                                local.get 9
                                i32.const 16843009
                                i32.sub
                                i32.and
                                i32.or
                                i32.const -2139062144
                                i32.and
                                br_if 3 (;@11;)
                                local.get 2
                                i32.const 8
                                i32.add
                                local.tee 2
                                local.get 15
                                i32.le_u
                                br_if 0 (;@14;)
                              end
                              br 2 (;@11;)
                            end
                            local.get 3
                            i32.load offset=20
                            local.set 1
                            i32.const 1
                            br 2 (;@10;)
                          end
                          local.get 3
                          local.get 8
                          local.get 1
                          local.get 6
                          call 62
                          local.get 3
                          i32.load offset=4
                          local.set 1
                          local.get 3
                          i32.load
                          br 1 (;@10;)
                        end
                        local.get 3
                        i32.const 8
                        i32.add
                        local.get 8
                        local.get 1
                        local.get 2
                        i32.add
                        local.get 6
                        local.get 2
                        i32.sub
                        call 62
                        local.get 3
                        i32.load offset=12
                        local.get 2
                        i32.add
                        local.set 1
                        local.get 3
                        i32.load offset=8
                      end
                      i32.const 1
                      i32.eq
                      if  ;; label = @10
                        local.get 3
                        local.get 1
                        local.get 4
                        i32.add
                        i32.const 1
                        i32.add
                        local.tee 4
                        i32.store offset=36
                        local.get 0
                        local.get 4
                        i32.gt_u
                        local.get 4
                        local.get 16
                        i32.gt_u
                        i32.or
                        br_if 2 (;@8;)
                        local.get 17
                        i32.eqz
                        br_if 1 (;@9;)
                        local.get 7
                        local.get 4
                        local.get 0
                        i32.sub
                        i32.add
                        local.set 1
                        local.get 1
                        local.get 13
                        local.get 0
                        call 11
                        br_if 2 (;@8;)
                        local.get 3
                        i32.load offset=52
                        local.set 0
                        local.get 3
                        local.get 4
                        i32.store offset=52
                        local.get 4
                        local.get 0
                        i32.sub
                        br 5 (;@5;)
                      end
                      local.get 3
                      local.get 5
                      i32.store offset=36
                      br 3 (;@6;)
                    end
                    local.get 0
                    i32.const 4
                    i32.const 67680
                    call 14
                    unreachable
                  end
                  local.get 4
                  local.get 5
                  i32.le_u
                  br_if 0 (;@7;)
                end
              end
              local.get 3
              i32.const 1
              i32.store8 offset=61
              block  ;; label = @6
                local.get 3
                i32.load8_u offset=60
                if  ;; label = @7
                  local.get 3
                  i32.load offset=56
                  local.set 2
                  local.get 3
                  i32.load offset=52
                  local.set 0
                  br 1 (;@6;)
                end
                local.get 3
                i32.load offset=56
                local.tee 2
                local.get 3
                i32.load offset=52
                local.tee 0
                i32.eq
                br_if 2 (;@4;)
              end
              local.get 2
              local.get 0
              i32.sub
            end
            local.set 1
            local.get 12
            i32.load8_u
            if  ;; label = @5
              local.get 11
              i32.const 67140
              i32.const 4
              local.get 10
              i32.load offset=12
              call_indirect (type 0)
              br_if 3 (;@2;)
            end
            local.get 0
            local.get 7
            i32.add
            local.set 0
            local.get 12
            local.get 1
            if (result i32)  ;; label = @5
              local.get 0
              local.get 1
              i32.add
              i32.const 1
              i32.sub
              i32.load8_u
              i32.const 10
              i32.eq
            else
              i32.const 0
            end
            i32.store8
            local.get 11
            local.get 0
            local.get 1
            local.get 10
            i32.load offset=12
            call_indirect (type 0)
            br_if 2 (;@2;)
            local.get 3
            i32.load8_u offset=61
            i32.eqz
            br_if 1 (;@3;)
          end
        end
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 1
    end
    local.set 0
    local.get 3
    i32.const -64
    i32.sub
    global.set 0
    local.get 0)
  (func (;29;) (type 2) (param i32 i32)
    (local i32 i32 i64 i64 i64)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    i32.const 8
    i32.add
    local.tee 3
    i64.const 0
    i64.store
    local.get 2
    i64.const 0
    i64.store
    block  ;; label = @1
      local.get 1
      local.get 2
      i32.const 16
      call 16
      i32.eqz
      if  ;; label = @2
        local.get 3
        i64.load
        local.set 5
        local.get 2
        i64.load
        local.set 6
        br 1 (;@1;)
      end
      i64.const 1
      local.set 4
    end
    local.get 0
    local.get 6
    i64.store offset=8
    local.get 0
    local.get 4
    i64.store
    local.get 0
    i32.const 16
    i32.add
    local.get 5
    i64.store
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;30;) (type 1) (param i32 i32) (result i32)
    local.get 1
    i32.const 0
    i32.store align=1
    local.get 0
    local.get 1
    i32.const 4
    call 16)
  (func (;31;) (type 2) (param i32 i32)
    (local i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    i64.const 16384
    i64.store offset=8 align=4
    local.get 2
    i32.const 68220
    i32.store offset=4
    local.get 2
    i32.const 4
    i32.add
    local.tee 3
    local.get 1
    if (result i32)  ;; label = @1
      local.get 3
      i32.const 1
      call 33
      i32.const 1
    else
      i32.const 0
    end
    call 33
    local.get 2
    i32.load offset=12
    local.tee 1
    i32.const 16385
    i32.ge_u
    if  ;; label = @1
      local.get 1
      i32.const 16384
      i32.const 66060
      call 14
      unreachable
    end
    local.get 0
    local.get 1
    call 34
    unreachable)
  (func (;32;) (type 6) (param i32)
    (local i32 i32 i32 i32 i32 i64)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 1
    global.set 0
    local.get 1
    i32.const 0
    i32.store offset=32
    local.get 1
    i64.const 16384
    i64.store offset=40 align=4
    local.get 1
    i32.const 68220
    i32.store offset=36
    local.get 1
    i32.const 36
    i32.add
    local.tee 2
    call 20
    local.get 1
    local.get 1
    i64.load offset=36 align=4
    i64.store offset=24 align=4
    local.get 1
    i32.const 16
    i32.add
    local.get 1
    i32.const 24
    i32.add
    local.tee 3
    local.get 1
    i32.load offset=44
    call 22
    local.get 1
    i32.load offset=20
    local.set 4
    local.get 1
    i32.load offset=16
    local.set 5
    local.get 1
    i64.load offset=24 align=4
    local.set 6
    local.get 1
    i32.const 0
    i32.store offset=44
    local.get 1
    local.get 6
    i64.store offset=36 align=4
    local.get 0
    local.get 2
    call 17
    local.get 0
    i64.load offset=32
    local.get 0
    i32.const 40
    i32.add
    i64.load
    local.get 2
    call 19
    local.get 1
    local.get 1
    i64.load offset=36 align=4
    i64.store offset=24 align=4
    local.get 1
    i32.const 8
    i32.add
    local.get 3
    local.get 1
    i32.load offset=44
    call 22
    local.get 5
    local.get 4
    local.get 1
    i32.load offset=8
    local.get 1
    i32.load offset=12
    call 6
    drop
    local.get 1
    i32.const 48
    i32.add
    global.set 0)
  (func (;33;) (type 2) (param i32 i32)
    (local i32 i32)
    local.get 0
    i32.load offset=8
    local.tee 2
    local.get 0
    i32.load offset=4
    local.tee 3
    i32.lt_u
    if  ;; label = @1
      local.get 0
      local.get 2
      i32.const 1
      i32.add
      i32.store offset=8
      local.get 0
      i32.load
      local.get 2
      i32.add
      local.get 1
      i32.store8
      return
    end
    global.get 0
    i32.const 48
    i32.sub
    local.tee 0
    global.set 0
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store
    local.get 0
    i32.const 44
    i32.add
    i32.const 4
    i32.store
    local.get 0
    i32.const 2
    i32.store offset=12
    local.get 0
    i32.const 67104
    i32.store offset=8
    local.get 0
    i64.const 2
    i64.store offset=20 align=4
    local.get 0
    i32.const 4
    i32.store offset=36
    local.get 0
    local.get 0
    i32.const 32
    i32.add
    i32.store offset=16
    local.get 0
    local.get 0
    i32.store offset=40
    local.get 0
    local.get 0
    i32.const 4
    i32.add
    i32.store offset=32
    local.get 0
    i32.const 8
    i32.add
    i32.const 68012
    call 25
    unreachable)
  (func (;34;) (type 2) (param i32 i32)
    local.get 0
    i32.const 68220
    local.get 1
    call 7
    unreachable)
  (func (;35;) (type 8)
    (local i32 i32 i32 i32 i32 i32 i32 i64 i64 i64)
    global.get 0
    i32.const 352
    i32.sub
    local.tee 0
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        call 21
        i32.const 255
        i32.and
        i32.const 5
        i32.eq
        if  ;; label = @3
          local.get 0
          i32.const 16384
          i32.store offset=160
          i32.const 68220
          local.get 0
          i32.const 160
          i32.add
          local.tee 3
          call 2
          local.get 0
          i32.const 80
          i32.add
          local.get 0
          i32.load offset=160
          i32.const 68220
          i32.const 16384
          call 13
          local.get 0
          local.get 0
          i64.load offset=80
          i64.store offset=260 align=4
          block  ;; label = @4
            local.get 0
            i32.const 260
            i32.add
            local.tee 1
            local.get 0
            i32.const 304
            i32.add
            local.tee 2
            call 30
            br_if 0 (;@4;)
            local.get 0
            i32.load offset=304
            i32.const 1065388211
            i32.ne
            br_if 0 (;@4;)
            local.get 0
            i32.const 268
            i32.add
            local.tee 4
            local.get 1
            call 15
            local.get 0
            i32.load8_u offset=268
            br_if 0 (;@4;)
            local.get 2
            local.get 1
            call 15
            local.get 0
            i32.load8_u offset=304
            br_if 0 (;@4;)
            local.get 0
            i32.const 72
            i32.add
            local.get 1
            call 26
            local.get 0
            i32.load offset=72
            br_if 0 (;@4;)
            local.get 0
            i32.load offset=76
            local.set 5
            local.get 0
            i64.const 0
            i64.store offset=344
            local.get 1
            local.get 0
            i32.const 344
            i32.add
            i32.const 8
            call 16
            br_if 0 (;@4;)
            local.get 0
            i64.load offset=344
            local.set 7
            local.get 0
            i32.const -64
            i32.sub
            local.get 1
            call 26
            local.get 0
            i32.load offset=64
            br_if 0 (;@4;)
            local.get 0
            i32.load offset=68
            local.set 6
            local.get 0
            i32.const 40
            i32.add
            local.get 1
            call 29
            local.get 0
            i64.load offset=40
            i32.wrap_i64
            br_if 0 (;@4;)
            local.get 0
            i32.const 56
            i32.add
            i64.load
            local.set 8
            local.get 0
            i64.load offset=48
            local.set 9
            local.get 0
            i32.const 112
            i32.add
            local.get 0
            i32.const 269
            i32.add
            local.tee 1
            i32.const 24
            i32.add
            i64.load align=1
            i64.store
            local.get 0
            i32.const 104
            i32.add
            local.get 1
            i32.const 16
            i32.add
            i64.load align=1
            i64.store
            local.get 0
            i32.const 96
            i32.add
            local.get 1
            i32.const 8
            i32.add
            i64.load align=1
            i64.store
            local.get 0
            i32.const 128
            i32.add
            local.get 0
            i32.const 305
            i32.add
            local.tee 2
            i32.const 8
            i32.add
            i64.load align=1
            i64.store
            local.get 0
            i32.const 136
            i32.add
            local.get 2
            i32.const 16
            i32.add
            i64.load align=1
            i64.store
            local.get 0
            i32.const 144
            i32.add
            local.get 2
            i32.const 24
            i32.add
            i64.load align=1
            i64.store
            local.get 0
            local.get 1
            i64.load align=1
            i64.store offset=88
            local.get 0
            local.get 2
            i64.load align=1
            i64.store offset=120
            local.get 3
            local.get 0
            i32.const 94
            i32.add
            local.get 0
            i32.const 166
            i32.add
            local.get 0
            i32.const 88
            i32.add
            local.tee 1
            i32.const 64
            call 8
            i32.const 64
            call 8
            i32.const 64
            call 8
            drop
            local.get 0
            i32.const 248
            i32.add
            local.get 8
            i64.store
            local.get 0
            local.get 9
            i64.store offset=240
            local.get 0
            local.get 6
            i32.store offset=236
            local.get 0
            local.get 5
            i32.store offset=232
            local.get 0
            local.get 7
            i64.store offset=224
            local.get 0
            i32.const 0
            i32.store offset=276
            local.get 0
            i64.const 16384
            i64.store offset=92 align=4
            local.get 0
            i32.const 68220
            i32.store offset=88
            local.get 1
            call 20
            local.get 0
            local.get 0
            i64.load offset=88 align=4
            i64.store offset=268 align=4
            local.get 0
            i32.const 32
            i32.add
            local.get 4
            local.get 0
            i32.load offset=96
            call 22
            local.get 0
            i32.load offset=36
            local.set 3
            local.get 0
            i32.load offset=32
            local.set 4
            local.get 0
            i32.load offset=268
            local.set 2
            local.get 0
            local.get 0
            i32.load offset=272
            local.tee 5
            i32.store offset=88
            local.get 4
            local.get 3
            local.get 2
            local.get 1
            call 0
            local.set 1
            local.get 0
            i32.const 24
            i32.add
            local.get 0
            i32.load offset=88
            local.get 2
            local.get 5
            call 13
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 1
                  br_table 0 (;@7;) 5 (;@2;) 5 (;@2;) 1 (;@6;) 5 (;@2;)
                end
                local.get 0
                i32.load offset=24
                local.set 1
                local.get 0
                local.get 0
                i32.load offset=28
                i32.store offset=348
                local.get 0
                local.get 1
                i32.store offset=344
                local.get 0
                i32.const 88
                i32.add
                local.get 0
                i32.const 344
                i32.add
                local.tee 1
                call 15
                local.get 0
                i32.load8_u offset=88
                i32.eqz
                if  ;; label = @7
                  local.get 0
                  i32.const 312
                  i32.add
                  local.tee 2
                  local.get 0
                  i32.const 98
                  i32.add
                  i64.load align=1
                  i64.store
                  local.get 0
                  i32.const 320
                  i32.add
                  local.tee 3
                  local.get 0
                  i32.const 106
                  i32.add
                  i64.load align=1
                  i64.store
                  local.get 0
                  i32.const 327
                  i32.add
                  local.tee 4
                  local.get 0
                  i32.const 113
                  i32.add
                  i64.load align=1
                  i64.store align=1
                  local.get 0
                  local.get 0
                  i64.load offset=90 align=1
                  i64.store offset=304
                  local.get 0
                  i32.load8_u offset=89
                  local.set 5
                  local.get 0
                  local.get 1
                  call 29
                  local.get 0
                  i64.load
                  i32.wrap_i64
                  i32.eqz
                  br_if 2 (;@5;)
                end
                local.get 0
                i32.const 0
                i32.store offset=104
                local.get 0
                i32.const 1
                i32.store offset=92
                local.get 0
                i32.const 66308
                i32.store offset=88
                br 5 (;@1;)
              end
              local.get 0
              i32.const 0
              i32.store offset=104
              local.get 0
              i32.const 1
              i32.store offset=92
              local.get 0
              i32.const 66260
              i32.store offset=88
              br 4 (;@1;)
            end
            local.get 0
            i32.const 16
            i32.add
            i64.load
            local.set 7
            local.get 0
            i64.load offset=8
            local.set 8
            local.get 0
            i32.const 112
            i32.add
            local.get 4
            i64.load align=1
            i64.store align=1
            local.get 0
            i32.const 105
            i32.add
            local.get 3
            i64.load
            i64.store align=1
            local.get 0
            i32.const 97
            i32.add
            local.get 2
            i64.load
            i64.store align=1
            local.get 0
            i32.const 128
            i32.add
            local.get 7
            i64.store
            local.get 0
            local.get 0
            i64.load offset=304
            i64.store offset=89 align=1
            local.get 0
            local.get 5
            i32.store8 offset=88
            local.get 0
            local.get 8
            i64.store offset=120
            local.get 0
            i32.const 160
            i32.add
            local.set 4
            global.get 0
            i32.const 96
            i32.sub
            local.tee 1
            global.set 0
            local.get 1
            i32.const 16384
            i32.store offset=48
            i32.const 68220
            local.get 1
            i32.const 48
            i32.add
            local.tee 2
            call 3
            local.get 1
            i32.const 16384
            i32.store offset=88
            local.get 1
            i32.const 68220
            i32.store offset=84
            local.get 2
            local.get 1
            i32.const 84
            i32.add
            local.tee 3
            call 15
            block  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.load8_u offset=48
                i32.eqz
                if  ;; label = @7
                  local.get 1
                  i32.const 16
                  i32.add
                  local.get 7
                  call 12
                  local.get 1
                  i32.const 32
                  i32.add
                  local.get 8
                  call 12
                  local.get 1
                  i64.load offset=24
                  i64.const 0
                  i64.ne
                  local.get 1
                  i32.const 40
                  i32.add
                  i64.load
                  local.tee 7
                  local.get 1
                  i64.load offset=16
                  i64.add
                  local.tee 8
                  local.get 7
                  i64.lt_u
                  i32.or
                  br_if 1 (;@6;)
                  local.get 1
                  i64.load offset=32
                  local.set 7
                  local.get 1
                  i32.const 0
                  i32.store offset=92
                  local.get 1
                  i64.const 16384
                  i64.store offset=52 align=4
                  local.get 1
                  i32.const 68220
                  i32.store offset=48
                  local.get 4
                  local.get 2
                  call 17
                  local.get 1
                  local.get 1
                  i64.load offset=48 align=4
                  i64.store offset=84 align=4
                  local.get 1
                  i32.const 8
                  i32.add
                  local.get 3
                  local.get 1
                  i32.load offset=56
                  call 22
                  local.get 1
                  i32.load offset=12
                  local.set 4
                  local.get 1
                  i32.load offset=8
                  local.set 5
                  local.get 1
                  i64.load offset=84 align=4
                  local.set 9
                  local.get 1
                  i32.const 0
                  i32.store offset=56
                  local.get 1
                  local.get 9
                  i64.store offset=48 align=4
                  local.get 7
                  local.get 8
                  local.get 2
                  call 19
                  local.get 1
                  local.get 1
                  i64.load offset=48 align=4
                  i64.store offset=84 align=4
                  local.get 1
                  local.get 3
                  local.get 1
                  i32.load offset=56
                  call 22
                  i32.const 2
                  local.set 2
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            i32.const 12
                                            local.get 5
                                            local.get 4
                                            local.get 1
                                            i32.load
                                            local.get 1
                                            i32.load offset=4
                                            call 5
                                            local.tee 3
                                            local.get 3
                                            i32.const 12
                                            i32.ge_u
                                            select
                                            i32.const 1
                                            i32.sub
                                            br_table 10 (;@10;) 11 (;@9;) 0 (;@20;) 1 (;@19;) 2 (;@18;) 3 (;@17;) 4 (;@16;) 5 (;@15;) 6 (;@14;) 7 (;@13;) 8 (;@12;) 9 (;@11;) 12 (;@8;)
                                          end
                                          i32.const 3
                                          local.set 2
                                          br 10 (;@9;)
                                        end
                                        i32.const 4
                                        local.set 2
                                        br 9 (;@9;)
                                      end
                                      i32.const 5
                                      local.set 2
                                      br 8 (;@9;)
                                    end
                                    i32.const 6
                                    local.set 2
                                    br 7 (;@9;)
                                  end
                                  i32.const 7
                                  local.set 2
                                  br 6 (;@9;)
                                end
                                i32.const 8
                                local.set 2
                                br 5 (;@9;)
                              end
                              i32.const 10
                              local.set 2
                              br 4 (;@9;)
                            end
                            i32.const 11
                            local.set 2
                            br 3 (;@9;)
                          end
                          i32.const 12
                          local.set 2
                          br 2 (;@9;)
                        end
                        i32.const 9
                        local.set 2
                        br 1 (;@9;)
                      end
                      i32.const 1
                      local.set 2
                    end
                    local.get 1
                    local.get 2
                    i32.store8 offset=48
                    i32.const 66364
                    i32.const 15
                    local.get 1
                    i32.const 48
                    i32.add
                    i32.const 65536
                    i32.const 66380
                    call 23
                    unreachable
                  end
                  local.get 1
                  i32.const 96
                  i32.add
                  global.set 0
                  br 2 (;@5;)
                end
                local.get 1
                i32.const 0
                i32.store8 offset=48
                i32.const 65864
                i32.const 65
                local.get 1
                i32.const 48
                i32.add
                i32.const 65536
                i32.const 66044
                call 23
                unreachable
              end
              global.get 0
              i32.const 16
              i32.sub
              local.tee 1
              global.set 0
              local.get 1
              i32.const 30
              i32.store offset=12
              local.get 1
              i32.const 66316
              i32.store offset=8
              global.get 0
              i32.const 32
              i32.sub
              local.tee 0
              global.set 0
              local.get 0
              i32.const 1
              i32.store offset=4
              local.get 0
              i32.const 67696
              i32.store
              local.get 0
              i64.const 1
              i64.store offset=12 align=4
              local.get 0
              i32.const 2
              i32.store offset=28
              local.get 0
              local.get 1
              i32.const 8
              i32.add
              i32.store offset=24
              local.get 0
              local.get 0
              i32.const 24
              i32.add
              i32.store offset=8
              local.get 0
              i32.const 66348
              call 25
              unreachable
            end
            local.get 0
            i32.const 88
            i32.add
            call 32
            i32.const 0
            i32.const 0
            call 31
            unreachable
          end
          i32.const 1
          i32.const 1
          call 31
          unreachable
        end
        local.get 0
        i32.const 4
        i32.store8 offset=160
        local.get 0
        i32.const 160
        i32.add
        call 36
        unreachable
      end
      local.get 0
      i32.const 0
      i32.store offset=104
      local.get 0
      i32.const 1
      i32.store offset=92
      local.get 0
      i32.const 66104
      i32.store offset=88
      local.get 0
      i64.const 4
      i64.store offset=96 align=4
      local.get 0
      i32.const 88
      i32.add
      i32.const 66112
      call 25
      unreachable
    end
    local.get 0
    i64.const 4
    i64.store offset=96 align=4
    local.get 0
    i32.const 88
    i32.add
    i32.const 66220
    call 25
    unreachable)
  (func (;36;) (type 6) (param i32)
    (local i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 1
    global.set 0
    local.get 1
    i32.const 1
    i32.store offset=4
    local.get 1
    i32.const 67696
    i32.store
    local.get 1
    i64.const 1
    i64.store offset=12 align=4
    local.get 1
    i32.const 3
    i32.store offset=28
    local.get 1
    local.get 0
    i32.store offset=24
    local.get 1
    local.get 1
    i32.const 24
    i32.add
    i32.store offset=8
    local.get 1
    i32.const 66220
    call 25
    unreachable)
  (func (;37;) (type 8)
    (local i32 i32 i32)
    global.get 0
    i32.const 112
    i32.sub
    local.tee 0
    global.set 0
    block  ;; label = @1
      call 21
      local.tee 1
      i32.const 255
      i32.and
      i32.const 5
      i32.eq
      if  ;; label = @2
        local.get 0
        i32.const 16384
        i32.store offset=64
        i32.const 68220
        local.get 0
        i32.const -64
        i32.sub
        local.tee 1
        call 2
        local.get 0
        i32.const 8
        i32.add
        local.get 0
        i32.load offset=64
        i32.const 68220
        i32.const 16384
        call 13
        local.get 0
        local.get 0
        i64.load offset=8
        i64.store offset=20 align=4
        block  ;; label = @3
          local.get 0
          i32.const 20
          i32.add
          local.tee 2
          local.get 1
          call 30
          br_if 0 (;@3;)
          local.get 0
          i32.load offset=64
          i32.const 1587392155
          i32.ne
          br_if 0 (;@3;)
          local.get 0
          i32.const 31
          i32.add
          local.get 2
          call 15
          local.get 0
          i32.load8_u offset=31
          i32.eqz
          br_if 2 (;@1;)
        end
        i32.const 1
        i32.const 1
        call 31
        unreachable
      end
      local.get 0
      local.get 1
      i32.store8 offset=64
      local.get 0
      i32.const -64
      i32.sub
      call 36
      unreachable
    end
    local.get 0
    i32.load8_u offset=32
    local.set 1
    local.get 0
    i32.const 88
    i32.add
    local.get 0
    i32.const 56
    i32.add
    i64.load align=1
    i64.store align=1
    local.get 0
    i32.const 81
    i32.add
    local.get 0
    i32.const 49
    i32.add
    i64.load align=1
    i64.store align=1
    local.get 0
    i32.const 73
    i32.add
    local.get 0
    i32.const 41
    i32.add
    i64.load align=1
    i64.store align=1
    local.get 0
    i32.const 104
    i32.add
    i64.const 0
    i64.store
    local.get 0
    local.get 0
    i64.load offset=33 align=1
    i64.store offset=65 align=1
    local.get 0
    i64.const 10
    i64.store offset=96
    local.get 0
    local.get 1
    i32.store8 offset=64
    local.get 0
    i32.const -64
    i32.sub
    call 32
    global.get 0
    i32.const 16
    i32.sub
    local.tee 0
    global.set 0
    local.get 0
    i64.const 16384
    i64.store offset=8 align=4
    local.get 0
    i32.const 68220
    i32.store offset=4
    local.get 0
    i32.const 4
    i32.add
    local.tee 1
    i32.const 0
    call 33
    local.get 1
    i32.const 0
    call 33
    local.get 0
    i32.load offset=12
    local.tee 0
    i32.const 16385
    i32.ge_u
    if  ;; label = @1
      local.get 0
      i32.const 16384
      i32.const 66060
      call 14
      unreachable
    end
    i32.const 0
    local.get 0
    call 34
    unreachable)
  (func (;38;) (type 4) (param i32 i32 i32)
    (local i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 4
    global.set 0
    block  ;; label = @1
      local.get 2
      local.get 0
      i32.load
      local.get 0
      i32.load offset=8
      local.tee 3
      i32.sub
      i32.gt_u
      if  ;; label = @2
        local.get 4
        i32.const 8
        i32.add
        local.get 0
        local.get 3
        local.get 2
        call 39
        local.get 4
        i32.load offset=8
        local.tee 3
        i32.const -2147483647
        i32.ne
        br_if 1 (;@1;)
        local.get 0
        i32.load offset=8
        local.set 3
      end
      local.get 0
      i32.load offset=4
      local.get 3
      i32.add
      local.get 1
      local.get 2
      call 8
      drop
      local.get 0
      local.get 2
      local.get 3
      i32.add
      i32.store offset=8
      local.get 4
      i32.const 16
      i32.add
      global.set 0
      return
    end
    local.get 3
    local.get 4
    i32.load offset=12
    call 40
    unreachable)
  (func (;39;) (type 5) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 5
    global.set 0
    block  ;; label = @1
      local.get 2
      local.get 2
      local.get 3
      i32.add
      local.tee 3
      i32.gt_u
      if  ;; label = @2
        i32.const 0
        local.set 2
        br 1 (;@1;)
      end
      i32.const 1
      local.set 2
      i32.const 8
      local.get 1
      i32.load
      local.tee 4
      i32.const 1
      i32.shl
      local.tee 6
      local.get 3
      local.get 3
      local.get 6
      i32.lt_u
      select
      local.tee 3
      local.get 3
      i32.const 8
      i32.le_u
      select
      local.tee 3
      i32.const -1
      i32.xor
      i32.const 31
      i32.shr_u
      local.set 7
      block  ;; label = @2
        local.get 4
        i32.eqz
        if  ;; label = @3
          i32.const 0
          local.set 2
          br 1 (;@2;)
        end
        local.get 5
        local.get 4
        i32.store offset=28
        local.get 5
        local.get 1
        i32.load offset=4
        i32.store offset=20
      end
      local.get 5
      local.get 2
      i32.store offset=24
      local.get 5
      i32.const 8
      i32.add
      local.set 8
      local.get 3
      local.set 2
      local.get 5
      i32.const 20
      i32.add
      local.set 4
      global.get 0
      i32.const 16
      i32.sub
      local.tee 6
      global.set 0
      block (result i32)  ;; label = @2
        block (result i32)  ;; label = @3
          block  ;; label = @4
            local.get 7
            if  ;; label = @5
              local.get 2
              i32.const 0
              i32.ge_s
              br_if 1 (;@4;)
              i32.const 1
              local.set 4
              i32.const 0
              local.set 2
              i32.const 4
              br 3 (;@2;)
            end
            local.get 8
            i32.const 0
            i32.store offset=4
            i32.const 1
            br 1 (;@3;)
          end
          block (result i32)  ;; label = @4
            local.get 4
            i32.load offset=4
            if  ;; label = @5
              local.get 4
              i32.load offset=8
              local.tee 7
              i32.eqz
              if  ;; label = @6
                local.get 6
                i32.const 8
                i32.add
                local.get 2
                call 41
                local.get 6
                i32.load offset=8
                local.set 4
                local.get 6
                i32.load offset=12
                br 2 (;@4;)
              end
              local.get 4
              i32.load
              local.set 9
              block  ;; label = @6
                local.get 2
                call 42
                local.tee 4
                i32.eqz
                if  ;; label = @7
                  i32.const 0
                  local.set 4
                  br 1 (;@6;)
                end
                local.get 4
                local.get 9
                local.get 7
                call 8
                drop
              end
              local.get 2
              br 1 (;@4;)
            end
            local.get 6
            local.get 2
            call 41
            local.get 6
            i32.load
            local.set 4
            local.get 6
            i32.load offset=4
          end
          local.set 7
          local.get 8
          local.get 4
          i32.const 1
          local.get 4
          select
          i32.store offset=4
          local.get 7
          local.get 2
          local.get 4
          select
          local.set 2
          local.get 4
          i32.eqz
        end
        local.set 4
        i32.const 8
      end
      local.get 8
      i32.add
      local.get 2
      i32.store
      local.get 8
      local.get 4
      i32.store
      local.get 6
      i32.const 16
      i32.add
      global.set 0
      local.get 5
      i32.load offset=12
      local.set 2
      local.get 5
      i32.load offset=8
      i32.eqz
      if  ;; label = @2
        local.get 1
        local.get 3
        i32.store
        local.get 1
        local.get 2
        i32.store offset=4
        i32.const -2147483647
        local.set 2
        br 1 (;@1;)
      end
      local.get 5
      i32.load offset=16
      local.set 1
    end
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store
    local.get 5
    i32.const 32
    i32.add
    global.set 0)
  (func (;40;) (type 2) (param i32 i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      global.get 0
      i32.const 32
      i32.sub
      local.tee 0
      global.set 0
      local.get 0
      i32.const 0
      i32.store offset=24
      local.get 0
      i32.const 1
      i32.store offset=12
      local.get 0
      i32.const 66464
      i32.store offset=8
      local.get 0
      i64.const 4
      i64.store offset=16 align=4
      local.get 0
      i32.const 8
      i32.add
      i32.const 66592
      call 25
      unreachable
    end
    global.get 0
    i32.const 48
    i32.sub
    local.tee 0
    global.set 0
    local.get 0
    local.get 1
    i32.store offset=12
    local.get 0
    i32.const 2
    i32.store offset=20
    local.get 0
    i32.const 66760
    i32.store offset=16
    local.get 0
    i64.const 1
    i64.store offset=28 align=4
    local.get 0
    i32.const 4
    i32.store offset=44
    local.get 0
    local.get 0
    i32.const 40
    i32.add
    i32.store offset=24
    local.get 0
    local.get 0
    i32.const 12
    i32.add
    i32.store offset=40
    global.get 0
    i32.const 32
    i32.sub
    local.tee 1
    global.set 0
    local.get 1
    i32.const 16
    i32.add
    local.get 0
    i32.const 16
    i32.add
    local.tee 0
    i32.const 16
    i32.add
    i64.load align=4
    i64.store
    local.get 1
    i32.const 8
    i32.add
    local.get 0
    i32.const 8
    i32.add
    i64.load align=4
    i64.store
    local.get 1
    i32.const 0
    i32.store16 offset=28
    local.get 1
    i32.const 66776
    i32.store offset=24
    local.get 1
    local.get 0
    i64.load align=4
    i64.store
    local.get 1
    call 50
    unreachable)
  (func (;41;) (type 2) (param i32 i32)
    (local i32)
    i32.const 84606
    i32.load8_u
    drop
    local.get 1
    call 42
    local.set 2
    local.get 0
    local.get 1
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store)
  (func (;42;) (type 12) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block (result i32)  ;; label = @2
        i32.const 0
        i32.const 68212
        i32.load
        local.tee 1
        local.get 0
        i32.add
        local.tee 2
        local.get 1
        i32.lt_u
        br_if 0 (;@2;)
        drop
        i32.const 68216
        i32.load
        local.get 2
        i32.lt_u
        if  ;; label = @3
          local.get 0
          i32.const 65535
          i32.add
          local.tee 2
          i32.const 16
          i32.shr_u
          memory.grow
          local.tee 1
          i32.const 65535
          i32.gt_u
          br_if 2 (;@1;)
          local.get 1
          i32.const 16
          i32.shl
          local.tee 1
          local.get 2
          i32.const -65536
          i32.and
          i32.add
          local.tee 2
          local.get 1
          i32.lt_u
          br_if 2 (;@1;)
          i32.const 68216
          local.get 2
          i32.store
          i32.const 0
          local.get 0
          local.get 1
          i32.add
          local.tee 2
          local.get 1
          i32.lt_u
          br_if 1 (;@2;)
          drop
        end
        i32.const 68212
        local.get 2
        i32.store
        local.get 1
      end
      return
    end
    i32.const 0)
  (func (;43;) (type 1) (param i32 i32) (result i32)
    local.get 0
    i32.const 66420
    local.get 1
    call 44)
  (func (;44;) (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const -64
    i32.add
    local.tee 3
    global.set 0
    local.get 3
    i32.const 3
    i32.store8 offset=60
    local.get 3
    i32.const 32
    i32.store offset=44
    local.get 3
    i32.const 0
    i32.store offset=56
    local.get 3
    local.get 1
    i32.store offset=52
    local.get 3
    local.get 0
    i32.store offset=48
    local.get 3
    i32.const 0
    i32.store offset=36
    local.get 3
    i32.const 0
    i32.store offset=28
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.load offset=16
          local.tee 1
          i32.eqz
          if  ;; label = @4
            local.get 2
            i32.load offset=12
            local.tee 0
            i32.const 3
            i32.shl
            local.set 5
            local.get 0
            i32.const 536870911
            i32.and
            local.set 6
            local.get 2
            i32.load offset=4
            local.set 8
            local.get 2
            i32.load
            local.set 7
            local.get 2
            i32.load offset=8
            local.set 1
            loop  ;; label = @5
              local.get 4
              local.get 5
              i32.eq
              br_if 2 (;@3;)
              local.get 4
              local.get 7
              i32.add
              local.tee 0
              i32.const 4
              i32.add
              i32.load
              local.tee 2
              if  ;; label = @6
                local.get 3
                i32.load offset=48
                local.get 0
                i32.load
                local.get 2
                local.get 3
                i32.load offset=52
                i32.load offset=12
                call_indirect (type 0)
                br_if 4 (;@2;)
              end
              local.get 4
              i32.const 8
              i32.add
              local.set 4
              local.get 1
              i32.load
              local.set 0
              local.get 1
              i32.load offset=4
              local.set 2
              local.get 1
              i32.const 8
              i32.add
              local.set 1
              local.get 0
              local.get 3
              i32.const 28
              i32.add
              local.get 2
              call_indirect (type 1)
              i32.eqz
              br_if 0 (;@5;)
            end
            br 2 (;@2;)
          end
          local.get 2
          i32.load offset=20
          local.tee 4
          i32.const 5
          i32.shl
          local.set 0
          local.get 4
          i32.const 134217727
          i32.and
          local.set 6
          local.get 2
          i32.load offset=12
          local.set 9
          local.get 2
          i32.load offset=8
          local.set 5
          local.get 2
          i32.load offset=4
          local.set 8
          local.get 2
          i32.load
          local.tee 7
          local.set 4
          loop  ;; label = @4
            local.get 0
            i32.eqz
            br_if 1 (;@3;)
            local.get 4
            i32.const 4
            i32.add
            i32.load
            local.tee 2
            if  ;; label = @5
              local.get 3
              i32.load offset=48
              local.get 4
              i32.load
              local.get 2
              local.get 3
              i32.load offset=52
              i32.load offset=12
              call_indirect (type 0)
              br_if 3 (;@2;)
            end
            local.get 3
            local.get 1
            i32.load offset=16
            i32.store offset=44
            local.get 3
            local.get 1
            i32.load8_u offset=28
            i32.store8 offset=60
            local.get 3
            local.get 1
            i32.load offset=24
            i32.store offset=56
            local.get 3
            i32.const 16
            i32.add
            local.get 5
            local.get 1
            i32.load offset=8
            local.get 1
            i32.const 12
            i32.add
            i32.load
            call 60
            local.get 3
            local.get 3
            i64.load offset=16
            i64.store offset=28 align=4
            local.get 3
            i32.const 8
            i32.add
            local.get 5
            local.get 1
            i32.load
            local.get 1
            i32.const 4
            i32.add
            i32.load
            call 60
            local.get 3
            local.get 3
            i64.load offset=8
            i64.store offset=36 align=4
            local.get 4
            i32.const 8
            i32.add
            local.set 4
            local.get 0
            i32.const 32
            i32.sub
            local.set 0
            local.get 1
            i32.load offset=20
            local.set 2
            local.get 1
            i32.const 32
            i32.add
            local.set 1
            local.get 5
            local.get 2
            i32.const 3
            i32.shl
            i32.add
            local.tee 2
            i32.load
            local.get 3
            i32.const 28
            i32.add
            local.get 2
            i32.load offset=4
            call_indirect (type 1)
            i32.eqz
            br_if 0 (;@4;)
          end
          br 1 (;@2;)
        end
        local.get 6
        local.get 8
        i32.lt_u
        if  ;; label = @3
          local.get 3
          i32.load offset=48
          local.get 7
          local.get 6
          i32.const 3
          i32.shl
          i32.add
          local.tee 0
          i32.load
          local.get 0
          i32.load offset=4
          local.get 3
          i32.load offset=52
          i32.load offset=12
          call_indirect (type 0)
          br_if 1 (;@2;)
        end
        i32.const 0
        br 1 (;@1;)
      end
      i32.const 1
    end
    local.set 1
    local.get 3
    i32.const -64
    i32.sub
    global.set 0
    local.get 1)
  (func (;45;) (type 6) (param i32)
    nop)
  (func (;46;) (type 0) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call 38
    i32.const 0)
  (func (;47;) (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    block  ;; label = @1
      block (result i32)  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.const 128
            i32.ge_u
            if  ;; label = @5
              local.get 2
              i32.const 0
              i32.store offset=12
              local.get 1
              i32.const 2048
              i32.lt_u
              br_if 1 (;@4;)
              local.get 1
              i32.const 65536
              i32.ge_u
              br_if 2 (;@3;)
              local.get 2
              local.get 1
              i32.const 12
              i32.shr_u
              i32.const 224
              i32.or
              i32.store8 offset=12
              local.get 2
              local.get 1
              i32.const 6
              i32.shr_u
              i32.const 63
              i32.and
              i32.const 128
              i32.or
              i32.store8 offset=13
              i32.const 2
              local.set 3
              i32.const 3
              br 3 (;@2;)
            end
            local.get 0
            i32.load offset=8
            local.tee 4
            local.get 0
            i32.load
            i32.eq
            if  ;; label = @5
              global.get 0
              i32.const 16
              i32.sub
              local.tee 3
              global.set 0
              local.get 3
              i32.const 8
              i32.add
              local.get 0
              local.get 0
              i32.load
              i32.const 1
              call 39
              local.get 3
              i32.load offset=8
              local.tee 5
              i32.const -2147483647
              i32.ne
              if  ;; label = @6
                local.get 5
                local.get 3
                i32.load offset=12
                call 40
                unreachable
              end
              local.get 3
              i32.const 16
              i32.add
              global.set 0
            end
            local.get 0
            local.get 4
            i32.const 1
            i32.add
            i32.store offset=8
            local.get 0
            i32.load offset=4
            local.get 4
            i32.add
            local.get 1
            i32.store8
            br 3 (;@1;)
          end
          local.get 2
          local.get 1
          i32.const 6
          i32.shr_u
          i32.const 192
          i32.or
          i32.store8 offset=12
          i32.const 1
          local.set 3
          i32.const 2
          br 1 (;@2;)
        end
        local.get 2
        local.get 1
        i32.const 6
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=14
        local.get 2
        local.get 1
        i32.const 12
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.store8 offset=13
        local.get 2
        local.get 1
        i32.const 18
        i32.shr_u
        i32.const 7
        i32.and
        i32.const 240
        i32.or
        i32.store8 offset=12
        i32.const 3
        local.set 3
        i32.const 4
      end
      local.set 4
      local.get 3
      local.get 2
      i32.const 12
      i32.add
      local.tee 5
      i32.or
      local.get 1
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8
      local.get 0
      local.get 5
      local.get 4
      call 38
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    i32.const 0)
  (func (;48;) (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i64)
    global.get 0
    i32.const -64
    i32.add
    local.tee 3
    global.set 0
    i32.const 39
    local.set 2
    block  ;; label = @1
      local.get 0
      i64.load32_u
      local.tee 13
      i64.const 10000
      i64.lt_u
      if  ;; label = @2
        local.get 13
        local.set 14
        br 1 (;@1;)
      end
      loop  ;; label = @2
        local.get 3
        i32.const 25
        i32.add
        local.get 2
        i32.add
        local.tee 0
        i32.const 4
        i32.sub
        local.get 13
        i64.const 10000
        i64.div_u
        local.tee 14
        i64.const 55536
        i64.mul
        local.get 13
        i64.add
        i32.wrap_i64
        local.tee 4
        i32.const 65535
        i32.and
        i32.const 100
        i32.div_u
        local.tee 6
        i32.const 1
        i32.shl
        i32.const 67149
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        local.get 0
        i32.const 2
        i32.sub
        local.get 6
        i32.const -100
        i32.mul
        local.get 4
        i32.add
        i32.const 65535
        i32.and
        i32.const 1
        i32.shl
        i32.const 67149
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        local.get 2
        i32.const 4
        i32.sub
        local.set 2
        local.get 13
        i64.const 99999999
        i64.gt_u
        local.set 0
        local.get 14
        local.set 13
        local.get 0
        br_if 0 (;@2;)
      end
    end
    local.get 14
    i32.wrap_i64
    local.tee 0
    i32.const 99
    i32.gt_u
    if  ;; label = @1
      local.get 2
      i32.const 2
      i32.sub
      local.tee 2
      local.get 3
      i32.const 25
      i32.add
      i32.add
      local.get 14
      i32.wrap_i64
      local.tee 4
      i32.const 65535
      i32.and
      i32.const 100
      i32.div_u
      local.tee 0
      i32.const -100
      i32.mul
      local.get 4
      i32.add
      i32.const 65535
      i32.and
      i32.const 1
      i32.shl
      i32.const 67149
      i32.add
      i32.load16_u align=1
      i32.store16 align=1
    end
    block  ;; label = @1
      local.get 0
      i32.const 10
      i32.ge_u
      if  ;; label = @2
        local.get 2
        i32.const 2
        i32.sub
        local.tee 2
        local.get 3
        i32.const 25
        i32.add
        i32.add
        local.get 0
        i32.const 1
        i32.shl
        i32.const 67149
        i32.add
        i32.load16_u align=1
        i32.store16 align=1
        br 1 (;@1;)
      end
      local.get 2
      i32.const 1
      i32.sub
      local.tee 2
      local.get 3
      i32.const 25
      i32.add
      i32.add
      local.get 0
      i32.const 48
      i32.or
      i32.store8
    end
    i32.const 1
    local.set 4
    local.get 1
    i32.load offset=28
    local.tee 5
    i32.const 1
    i32.and
    local.tee 7
    i32.const 39
    local.get 2
    i32.sub
    local.tee 6
    i32.add
    local.set 0
    block  ;; label = @1
      local.get 5
      i32.const 4
      i32.and
      i32.eqz
      if  ;; label = @2
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      i32.const 1
      i32.const 1
      call 51
      local.get 0
      i32.add
      local.set 0
    end
    i32.const 43
    i32.const 1114112
    local.get 7
    select
    local.set 7
    local.get 3
    i32.const 25
    i32.add
    local.get 2
    i32.add
    local.set 8
    block  ;; label = @1
      local.get 1
      i32.load
      i32.eqz
      if  ;; label = @2
        i32.const 1
        local.set 2
        local.get 1
        i32.load offset=20
        local.tee 0
        local.get 1
        i32.load offset=24
        local.tee 1
        local.get 7
        local.get 4
        call 53
        br_if 1 (;@1;)
        local.get 0
        local.get 8
        local.get 6
        local.get 1
        i32.load offset=12
        call_indirect (type 0)
        local.set 2
        br 1 (;@1;)
      end
      local.get 0
      local.get 1
      i32.load offset=4
      local.tee 9
      i32.ge_u
      if  ;; label = @2
        i32.const 1
        local.set 2
        local.get 1
        i32.load offset=20
        local.tee 0
        local.get 1
        i32.load offset=24
        local.tee 1
        local.get 7
        local.get 4
        call 53
        br_if 1 (;@1;)
        local.get 0
        local.get 8
        local.get 6
        local.get 1
        i32.load offset=12
        call_indirect (type 0)
        local.set 2
        br 1 (;@1;)
      end
      local.get 5
      i32.const 8
      i32.and
      if  ;; label = @2
        local.get 1
        i32.load offset=16
        local.set 11
        local.get 1
        i32.const 48
        i32.store offset=16
        local.get 1
        i32.load8_u offset=32
        local.set 12
        i32.const 1
        local.set 2
        local.get 1
        i32.const 1
        i32.store8 offset=32
        local.get 1
        i32.load offset=20
        local.tee 5
        local.get 1
        i32.load offset=24
        local.tee 10
        local.get 7
        local.get 4
        call 53
        br_if 1 (;@1;)
        local.get 3
        i32.const 16
        i32.add
        local.get 1
        local.get 9
        local.get 0
        i32.sub
        i32.const 1
        call 54
        local.get 3
        i32.load offset=16
        local.tee 0
        i32.const 1114112
        i32.eq
        br_if 1 (;@1;)
        local.get 3
        i32.load offset=20
        local.set 4
        local.get 5
        local.get 8
        local.get 6
        local.get 10
        i32.load offset=12
        call_indirect (type 0)
        br_if 1 (;@1;)
        local.get 0
        local.get 4
        local.get 5
        local.get 10
        call 55
        br_if 1 (;@1;)
        local.get 1
        local.get 12
        i32.store8 offset=32
        local.get 1
        local.get 11
        i32.store offset=16
        i32.const 0
        local.set 2
        br 1 (;@1;)
      end
      i32.const 1
      local.set 2
      local.get 3
      i32.const 8
      i32.add
      local.get 1
      local.get 9
      local.get 0
      i32.sub
      i32.const 1
      call 54
      local.get 3
      i32.load offset=8
      local.tee 5
      i32.const 1114112
      i32.eq
      br_if 0 (;@1;)
      local.get 3
      i32.load offset=12
      local.set 9
      local.get 1
      i32.load offset=20
      local.tee 0
      local.get 1
      i32.load offset=24
      local.tee 1
      local.get 7
      local.get 4
      call 53
      br_if 0 (;@1;)
      local.get 0
      local.get 8
      local.get 6
      local.get 1
      i32.load offset=12
      call_indirect (type 0)
      br_if 0 (;@1;)
      local.get 5
      local.get 9
      local.get 0
      local.get 1
      call 55
      local.set 2
    end
    local.get 3
    i32.const -64
    i32.sub
    global.set 0
    local.get 2)
  (func (;49;) (type 1) (param i32 i32) (result i32)
    local.get 1
    i32.load offset=20
    i32.const 66412
    i32.const 5
    local.get 1
    i32.load offset=24
    i32.load offset=12
    call_indirect (type 0))
  (func (;50;) (type 6) (param i32)
    (local i32)
    global.get 0
    i32.const -64
    i32.add
    local.tee 1
    global.set 0
    local.get 1
    local.get 0
    i32.store offset=12
    local.get 1
    i32.const 2
    i32.store offset=20
    local.get 1
    i32.const 67848
    i32.store offset=16
    local.get 1
    i64.const 1
    i64.store offset=28 align=4
    local.get 1
    i32.const 5
    i32.store offset=44
    local.get 1
    local.get 1
    i32.const 40
    i32.add
    i32.store offset=24
    local.get 1
    local.get 1
    i32.const 12
    i32.add
    i32.store offset=40
    local.get 1
    i32.const 0
    i32.store offset=56
    local.get 1
    i64.const 4294967296
    i64.store offset=48 align=4
    local.get 1
    i32.const 48
    i32.add
    local.get 1
    i32.const 16
    i32.add
    call 43
    i32.eqz
    if  ;; label = @1
      local.get 1
      i32.load offset=52
      local.set 0
      local.get 1
      i32.load offset=56
      local.set 1
      block  ;; label = @2
        i32.const 84604
        i32.load8_u
        i32.eqz
        if  ;; label = @3
          i32.const 84605
          i32.load8_u
          br_if 1 (;@2;)
        end
        local.get 0
        local.get 1
        call 4
        i32.const 9
        i32.ne
        if  ;; label = @3
          i32.const 84604
          i32.const 1
          i32.store8
        end
        i32.const 84605
        i32.const 1
        i32.store8
      end
      unreachable
    end
    i32.const 66792
    i32.const 86
    local.get 1
    i32.const 63
    i32.add
    i32.const 66396
    i32.const 66996
    call 23
    unreachable)
  (func (;51;) (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      local.get 0
      i32.sub
      local.tee 2
      i32.const 16
      i32.ge_u
      if  ;; label = @2
        local.get 0
        local.get 0
        i32.const 3
        i32.add
        i32.const -4
        i32.and
        local.tee 1
        local.get 0
        i32.sub
        local.tee 0
        call 52
        local.get 1
        local.get 2
        local.get 0
        i32.sub
        local.tee 0
        i32.const -4
        i32.and
        i32.add
        local.get 0
        i32.const 3
        i32.and
        call 52
        i32.add
        local.set 3
        local.get 0
        i32.const 2
        i32.shr_u
        local.set 0
        loop  ;; label = @3
          local.get 1
          local.set 2
          local.get 0
          local.tee 4
          i32.eqz
          br_if 2 (;@1;)
          i32.const 192
          local.get 0
          local.get 0
          i32.const 192
          i32.ge_u
          select
          local.tee 5
          i32.const 2
          i32.shl
          local.set 7
          i32.const 0
          local.set 0
          local.get 4
          i32.const 4
          i32.ge_u
          if  ;; label = @4
            local.get 1
            local.get 7
            i32.const 1008
            i32.and
            i32.add
            local.set 8
            local.get 1
            local.set 6
            loop  ;; label = @5
              i32.const 0
              local.set 1
              loop  ;; label = @6
                local.get 0
                local.get 1
                local.get 6
                i32.add
                i32.load
                local.tee 0
                i32.const -1
                i32.xor
                i32.const 7
                i32.shr_u
                local.get 0
                i32.const 6
                i32.shr_u
                i32.or
                i32.const 16843009
                i32.and
                i32.add
                local.set 0
                local.get 1
                i32.const 4
                i32.add
                local.tee 1
                i32.const 16
                i32.ne
                br_if 0 (;@6;)
              end
              local.get 6
              i32.const 16
              i32.add
              local.tee 6
              local.get 8
              i32.ne
              br_if 0 (;@5;)
            end
          end
          local.get 0
          i32.const 8
          i32.shr_u
          i32.const 16711935
          i32.and
          local.get 0
          i32.const 16711935
          i32.and
          i32.add
          i32.const 65537
          i32.mul
          i32.const 16
          i32.shr_u
          local.get 3
          i32.add
          local.set 3
          local.get 4
          local.get 5
          i32.sub
          local.set 0
          local.get 2
          local.get 7
          i32.add
          local.set 1
          local.get 5
          i32.const 3
          i32.and
          i32.eqz
          br_if 0 (;@3;)
        end
        local.get 2
        local.get 5
        i32.const 252
        i32.and
        i32.const 2
        i32.shl
        i32.add
        local.set 1
        i32.const 192
        local.get 4
        local.get 4
        i32.const 192
        i32.ge_u
        select
        i32.const 3
        i32.and
        i32.const 2
        i32.shl
        local.set 2
        i32.const 0
        local.set 0
        loop  ;; label = @3
          local.get 0
          local.get 1
          i32.load
          local.tee 0
          i32.const -1
          i32.xor
          i32.const 7
          i32.shr_u
          local.get 0
          i32.const 6
          i32.shr_u
          i32.or
          i32.const 16843009
          i32.and
          i32.add
          local.set 0
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 2
          i32.const 4
          i32.sub
          local.tee 2
          br_if 0 (;@3;)
        end
        local.get 0
        i32.const 8
        i32.shr_u
        i32.const 16711935
        i32.and
        local.get 0
        i32.const 16711935
        i32.and
        i32.add
        i32.const 65537
        i32.mul
        i32.const 16
        i32.shr_u
        local.get 3
        i32.add
        return
      end
      local.get 0
      local.get 2
      call 52
      local.set 3
    end
    local.get 3)
  (func (;52;) (type 1) (param i32 i32) (result i32)
    (local i32)
    local.get 1
    if  ;; label = @1
      loop  ;; label = @2
        local.get 2
        local.get 0
        i32.load8_s
        i32.const -65
        i32.gt_s
        i32.add
        local.set 2
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 1
        i32.const 1
        i32.sub
        local.tee 1
        br_if 0 (;@2;)
      end
    end
    local.get 2)
  (func (;53;) (type 3) (param i32 i32 i32 i32) (result i32)
    block  ;; label = @1
      block (result i32)  ;; label = @2
        local.get 2
        i32.const 1114112
        i32.ne
        if  ;; label = @3
          i32.const 1
          local.get 0
          local.get 2
          local.get 1
          i32.load offset=16
          call_indirect (type 1)
          br_if 1 (;@2;)
          drop
        end
        local.get 3
        br_if 1 (;@1;)
        i32.const 0
      end
      return
    end
    local.get 0
    local.get 3
    i32.const 0
    local.get 1
    i32.load offset=12
    call_indirect (type 0))
  (func (;54;) (type 5) (param i32 i32 i32 i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.load8_u offset=32
            local.tee 4
            i32.const 1
            i32.sub
            br_table 1 (;@3;) 2 (;@2;) 0 (;@4;) 3 (;@1;)
          end
          local.get 3
          i32.const 255
          i32.and
          br_if 0 (;@3;)
          i32.const 0
          local.set 4
          br 2 (;@1;)
        end
        local.get 2
        local.set 4
        i32.const 0
        local.set 2
        br 1 (;@1;)
      end
      local.get 2
      i32.const 1
      i32.shr_u
      local.set 4
      local.get 2
      i32.const 1
      i32.add
      i32.const 1
      i32.shr_u
      local.set 2
    end
    local.get 4
    i32.const 1
    i32.add
    local.set 4
    local.get 1
    i32.load offset=16
    local.set 3
    local.get 1
    i32.load offset=24
    local.set 5
    local.get 1
    i32.load offset=20
    local.set 1
    block  ;; label = @1
      loop  ;; label = @2
        local.get 4
        i32.const 1
        i32.sub
        local.tee 4
        i32.eqz
        br_if 1 (;@1;)
        local.get 1
        local.get 3
        local.get 5
        i32.load offset=16
        call_indirect (type 1)
        i32.eqz
        br_if 0 (;@2;)
      end
      i32.const 1114112
      local.set 3
    end
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0
    local.get 3
    i32.store)
  (func (;55;) (type 3) (param i32 i32 i32 i32) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      loop  ;; label = @2
        local.get 1
        local.get 1
        local.get 4
        i32.eq
        br_if 1 (;@1;)
        drop
        local.get 4
        i32.const 1
        i32.add
        local.set 4
        local.get 2
        local.get 0
        local.get 3
        i32.load offset=16
        call_indirect (type 1)
        i32.eqz
        br_if 0 (;@2;)
      end
      local.get 4
      i32.const 1
      i32.sub
    end
    local.get 1
    i32.lt_u)
  (func (;56;) (type 7) (param i32 i32 i32 i32 i32)
    local.get 1
    local.get 3
    i32.eq
    if  ;; label = @1
      local.get 0
      local.get 2
      local.get 1
      call 8
      drop
      return
    end
    global.get 0
    i32.const 48
    i32.sub
    local.tee 0
    global.set 0
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store
    local.get 0
    i32.const 44
    i32.add
    i32.const 4
    i32.store
    local.get 0
    i32.const 3
    i32.store offset=12
    local.get 0
    i32.const 67532
    i32.store offset=8
    local.get 0
    i64.const 2
    i64.store offset=20 align=4
    local.get 0
    i32.const 4
    i32.store offset=36
    local.get 0
    local.get 0
    i32.const 32
    i32.add
    i32.store offset=16
    local.get 0
    local.get 0
    i32.store offset=40
    local.get 0
    local.get 0
    i32.const 4
    i32.add
    i32.store offset=32
    local.get 0
    i32.const 8
    i32.add
    local.get 4
    call 25
    unreachable)
  (func (;57;) (type 2) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    local.get 0
    block (result i32)  ;; label = @1
      i32.const 1114112
      local.get 1
      i32.load
      local.tee 2
      local.get 1
      i32.load offset=4
      i32.eq
      br_if 0 (;@1;)
      drop
      local.get 1
      local.get 2
      i32.const 1
      i32.add
      local.tee 5
      i32.store
      block  ;; label = @2
        local.get 2
        i32.load8_u
        local.tee 3
        i32.const 24
        i32.shl
        i32.const 24
        i32.shr_s
        i32.const 0
        i32.ge_s
        br_if 0 (;@2;)
        local.get 1
        local.get 2
        i32.const 2
        i32.add
        local.tee 5
        i32.store
        local.get 2
        i32.load8_u offset=1
        i32.const 63
        i32.and
        local.set 4
        local.get 3
        i32.const 31
        i32.and
        local.set 6
        local.get 3
        i32.const 223
        i32.le_u
        if  ;; label = @3
          local.get 6
          i32.const 6
          i32.shl
          local.get 4
          i32.or
          local.set 3
          br 1 (;@2;)
        end
        local.get 1
        local.get 2
        i32.const 3
        i32.add
        local.tee 5
        i32.store
        local.get 2
        i32.load8_u offset=2
        i32.const 63
        i32.and
        local.get 4
        i32.const 6
        i32.shl
        i32.or
        local.set 4
        local.get 3
        i32.const 240
        i32.lt_u
        if  ;; label = @3
          local.get 4
          local.get 6
          i32.const 12
          i32.shl
          i32.or
          local.set 3
          br 1 (;@2;)
        end
        local.get 1
        local.get 2
        i32.const 4
        i32.add
        local.tee 5
        i32.store
        i32.const 1114112
        local.get 6
        i32.const 18
        i32.shl
        i32.const 1835008
        i32.and
        local.get 2
        i32.load8_u offset=3
        i32.const 63
        i32.and
        local.get 4
        i32.const 6
        i32.shl
        i32.or
        i32.or
        local.tee 3
        i32.const 1114112
        i32.eq
        br_if 1 (;@1;)
        drop
      end
      local.get 1
      local.get 1
      i32.load offset=8
      local.tee 7
      local.get 5
      local.get 2
      i32.sub
      i32.add
      i32.store offset=8
      local.get 3
    end
    i32.store offset=4
    local.get 0
    local.get 7
    i32.store)
  (func (;58;) (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i32.load offset=4
    local.set 4
    local.get 0
    i32.load
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load
        local.tee 6
        local.get 1
        i32.load offset=8
        local.tee 0
        i32.or
        if  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            i32.load offset=12
            local.set 0
            local.get 2
            i32.const 0
            i32.store offset=44
            local.get 2
            local.get 3
            i32.store offset=36
            local.get 2
            local.get 3
            local.get 4
            i32.add
            i32.store offset=40
            local.get 0
            i32.const 1
            i32.add
            local.set 0
            loop  ;; label = @5
              local.get 0
              i32.const 1
              i32.sub
              local.tee 0
              if  ;; label = @6
                local.get 2
                i32.const 24
                i32.add
                local.get 2
                i32.const 36
                i32.add
                call 57
                local.get 2
                i32.load offset=28
                i32.const 1114112
                i32.ne
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
            end
            local.get 2
            i32.const 16
            i32.add
            local.get 2
            i32.const 36
            i32.add
            call 57
            local.get 2
            i32.load offset=20
            i32.const 1114112
            i32.eq
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 2
                i32.load offset=16
                local.tee 5
                i32.eqz
                br_if 0 (;@6;)
                local.get 4
                local.get 5
                i32.le_u
                if  ;; label = @7
                  i32.const 0
                  local.set 0
                  local.get 4
                  local.get 5
                  i32.eq
                  br_if 1 (;@6;)
                  br 2 (;@5;)
                end
                i32.const 0
                local.set 0
                local.get 3
                local.get 5
                i32.add
                i32.load8_s
                i32.const -64
                i32.lt_s
                br_if 1 (;@5;)
              end
              local.get 3
              local.set 0
            end
            local.get 5
            local.get 4
            local.get 0
            select
            local.set 4
            local.get 0
            local.get 3
            local.get 0
            select
            local.set 3
          end
          local.get 6
          i32.eqz
          if  ;; label = @4
            local.get 1
            i32.load offset=20
            local.get 3
            local.get 4
            local.get 1
            i32.load offset=24
            i32.load offset=12
            call_indirect (type 0)
            local.set 0
            br 3 (;@1;)
          end
          local.get 1
          i32.load offset=4
          local.tee 0
          local.get 3
          local.get 3
          local.get 4
          i32.add
          call 51
          local.tee 5
          i32.le_u
          br_if 1 (;@2;)
          local.get 2
          i32.const 8
          i32.add
          local.get 1
          local.get 0
          local.get 5
          i32.sub
          i32.const 0
          call 54
          i32.const 1
          local.set 0
          local.get 2
          i32.load offset=8
          local.tee 5
          i32.const 1114112
          i32.eq
          br_if 2 (;@1;)
          local.get 2
          i32.load offset=12
          local.set 6
          local.get 1
          i32.load offset=20
          local.tee 7
          local.get 3
          local.get 4
          local.get 1
          i32.load offset=24
          local.tee 1
          i32.load offset=12
          call_indirect (type 0)
          br_if 2 (;@1;)
          local.get 5
          local.get 6
          local.get 7
          local.get 1
          call 55
          local.set 0
          br 2 (;@1;)
        end
        local.get 1
        i32.load offset=20
        local.get 3
        local.get 4
        local.get 1
        i32.load offset=24
        i32.load offset=12
        call_indirect (type 0)
        local.set 0
        br 1 (;@1;)
      end
      local.get 1
      i32.load offset=20
      local.get 3
      local.get 4
      local.get 1
      i32.load offset=24
      i32.load offset=12
      call_indirect (type 0)
      local.set 0
    end
    local.get 2
    i32.const 48
    i32.add
    global.set 0
    local.get 0)
  (func (;59;) (type 1) (param i32 i32) (result i32)
    local.get 0
    i32.load
    local.get 1
    local.get 0
    i32.load offset=4
    i32.load offset=12
    call_indirect (type 1))
  (func (;60;) (type 5) (param i32 i32 i32 i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.const 1
          i32.sub
          br_table 1 (;@2;) 2 (;@1;) 0 (;@3;)
        end
        i32.const 1
        local.set 4
        br 1 (;@1;)
      end
      local.get 1
      local.get 3
      i32.const 3
      i32.shl
      i32.add
      local.tee 1
      i32.load
      local.set 3
      local.get 1
      i32.load offset=4
      i32.eqz
      local.set 4
    end
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 4
    i32.store)
  (func (;61;) (type 0) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call 44)
  (func (;62;) (type 5) (param i32 i32 i32 i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.eqz
        if  ;; label = @3
          i32.const 0
          local.set 3
          br 1 (;@2;)
        end
        local.get 1
        i32.const 255
        i32.and
        local.set 5
        i32.const 1
        local.set 1
        loop  ;; label = @3
          local.get 5
          local.get 2
          local.get 4
          i32.add
          i32.load8_u
          i32.eq
          if  ;; label = @4
            local.get 4
            local.set 3
            br 3 (;@1;)
          end
          local.get 3
          local.get 4
          i32.const 1
          i32.add
          local.tee 4
          i32.ne
          br_if 0 (;@3;)
        end
      end
      i32.const 0
      local.set 1
    end
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store)
  (func (;63;) (type 1) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i32.load
    local.set 4
    i32.const 1
    local.set 0
    block  ;; label = @1
      local.get 1
      i32.load offset=20
      local.tee 3
      i32.const 67040
      i32.const 12
      local.get 1
      i32.load offset=24
      local.tee 5
      i32.load offset=12
      local.tee 6
      call_indirect (type 0)
      br_if 0 (;@1;)
      local.get 4
      i32.load offset=24
      local.set 1
      local.get 2
      i32.const 44
      i32.add
      i32.const 4
      i32.store
      local.get 2
      i32.const 36
      i32.add
      i32.const 4
      i32.store
      local.get 2
      i32.const 3
      i32.store offset=4
      local.get 2
      i32.const 67016
      i32.store
      local.get 2
      i64.const 3
      i64.store offset=12 align=4
      local.get 2
      local.get 1
      i32.const 12
      i32.add
      i32.store offset=40
      local.get 2
      local.get 1
      i32.const 8
      i32.add
      i32.store offset=32
      local.get 2
      i32.const 2
      i32.store offset=28
      local.get 2
      local.get 1
      i32.store offset=24
      local.get 2
      local.get 2
      i32.const 24
      i32.add
      i32.store offset=8
      local.get 3
      local.get 5
      local.get 2
      call 61
      br_if 0 (;@1;)
      local.get 3
      i32.const 67052
      i32.const 2
      local.get 6
      call_indirect (type 0)
      br_if 0 (;@1;)
      local.get 3
      local.get 5
      local.get 4
      call 61
      local.set 0
    end
    local.get 2
    i32.const 48
    i32.add
    global.set 0
    local.get 0)
  (table (;0;) 12 12 funcref)
  (global (;0;) (mut i32) (i32.const 65536))
  (global (;1;) i32 (i32.const 84607))
  (global (;2;) i32 (i32.const 84608))
  (export "call" (func 35))
  (export "deploy" (func 37)))